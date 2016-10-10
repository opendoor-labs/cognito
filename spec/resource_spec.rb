# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Resource do
  subject(:person) do
    Person.build(data.fetch(:data), Cognito::Document.new(data))
  end

  before(:each) do
    stub_const('Cognito::Resource::REGISTRY', Cognito::Resource::Registry.new)
    stub_const('Person', Class.new(described_class))

    class Person < described_class
      register_type :person

      one  :father
      one  :mother
      many :cousins
      many :siblings

      attribute :name
      attribute :foo_bar
      attribute :phone, :fone
    end # Person
  end

  let(:data) do
    {
      data:     {
        type:          'person',
        id:            '1',
        attributes:    { name: 'John', phone: 'ring! ring!' },
        relationships: {
          father:   {
            data: {
              type: 'person',
              id:   '2'
            }
          },
          mother:   {
            data: nil
          },
          cousins:  {
            data: [
              {
                type: 'person',
                id:   '4'
              }
            ]
          },
          siblings: {
            data: [
              {
                type: 'person',
                id:   '3'
              }
            ]
          }
        }
      },
      included: [
        {
          type:          'person',
          id:            '2',
          attributes:    { name: 'Jim' },
          relationships: {}
        },
        {
          type:          'person',
          id:            '3',
          attributes:    { name: 'Sally' },
          relationships: {
            siblings: {
              data: [
                {
                  type: 'person',
                  id:   '1'
                }
              ]
            }
          }
        }
      ]
    }
  end

  its(:id)   { should eql('1')      }
  its(:type) { should eql('person') }
  its(:name) { should eql('John') }
  its(:foo_bar) { should eql(nil) }
  its(:fone) { should eql('ring! ring!') }

  it 'exposes has_one relationship via #father' do
    expect(person.father.id).to eql('2')
  end

  it 'exposes nested relationships' do
    expect(person.siblings.first.siblings.first.id).to eql('1')
  end

  it 'memoizes relationships' do
    expect(person.father).to equal(person.father)
  end

  it 'allows the relationship to be null' do
    expect(person.mother).to be(nil)
  end

  it 'supports including additional resources' do
    expect { person.cousins }.to raise_error(KeyError)

    cousin_data = {
      type:          'person',
      id:            '4',
      attributes:    { name: 'Delmer' },
      relationships: {}
    }

    cousin = instance_double(Person, included: [cousin_data])

    person_with_cousin = person.include(cousin)

    expect(person_with_cousin.cousins.first.name).to eql('Delmer')
    expect(person_with_cousin.included).to eql(
      person.included + cousin.included
    )
  end

  it 'supports including additional resources into children' do
    sibling = person.siblings.first

    cousin_data = {
      type:          'person',
      id:            '4',
      attributes:    { name: 'Delmer' },
      relationships: {}
    }

    cousin = instance_double(Person, included: [cousin_data])

    sibling_with_cousin         = sibling.include(cousin)
    original_person_with_cousin = sibling_with_cousin.siblings.first

    expect(original_person_with_cousin.cousins.first.name).to eql('Delmer')
  end

  context 'missing relations' do
    let(:sloppy) do
      document = Cognito::Document.new(
        data:     {
          type:          'slop',
          id:            '42',
          attributes:    {},
          relationships: {
            relation_with_nil_relations:   {
              data: {
                type: 'slop',
                id:   '43'
              }
            },
            relation_with_empty_relations: {
              data: {
                type: 'slop',
                id:   '44'
              }
            }
          }
        },
        included: [
          {
            type:       'slop',
            id:         '43',
            attributes: {}
          },
          {
            type:          'slop',
            id:            '44',
            attributes:    {},
            relationships: {}
          }
        ]
      )

      Sloppy.build(document.data, document)
    end

    before do
      stub_const('Sloppy', Class.new(described_class))

      class Sloppy
        register_type :slop

        one :relation_with_empty_relations
        one :relation_with_nil_relations

        def inspect
          '#<Sloppy>'
        end
      end # Sloppy
    end

    it 'correctly errors for missing relationship identifiers' do
      expect(sloppy.relation_with_nil_relations).to have_attributes(
        type:          'slop',
        id:            '43',
        attributes:    {},
        relationships: nil
      )

      aggregate_failures('errors fetching missing relations') do
        expect { sloppy.relation_with_nil_relations.relation_with_nil_relations }
          .to raise_error(Cognito::Resource::MissingRelation)
          .with_message(/relation_with_nil_relations.+not in.+#<Sloppy>/)

        expect { sloppy.relation_with_empty_relations.relation_with_empty_relations }
          .to raise_error(Cognito::Resource::MissingRelation)
          .with_message(/relation_with_empty_relations.+not in.+#<Sloppy>/)
      end
    end
  end

  context 'registering resource types' do
    it 'rejects duplciate registrations' do
      expect { Class.new(described_class) { register_type(:person) } }
        .to raise_error(described_class::Registry::DuplicateTypeError)
        .with_message(/already registered: person/)
    end

    it 'fails lookups for undefined types' do
      expect { described_class::REGISTRY.lookup(:nope) }
        .to raise_error(described_class::Registry::MissingError)
        .with_message(/not registered: nope/)
    end
  end
end
