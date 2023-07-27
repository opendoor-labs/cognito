# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Document do
  subject(:document) { described_class.new(response) }

  let(:response) do
    {
      data:     {
        type:          'foobar',
        id:            'abc123',
        attributes:    {},
        relationships: {}
      },
      included: [
        {
          type:          'other_bar',
          id:            'xyz123',
          attributes:    {},
          relationships: {}
        }
      ]
    }
  end

  it 'can resolve the root data item' do
    expect(document.resolve(type: 'foobar', id: 'abc123'))
      .to eql(
        type:          'foobar',
        id:            'abc123',
        attributes:    {},
        relationships: {}
      )
  end

  it 'can resolve included data items' do
    expect(document.resolve(type: 'other_bar', id: 'xyz123'))
      .to eql(
        type:          'other_bar',
        id:            'xyz123',
        attributes:    {},
        relationships: {}
      )
  end

  it 'can include new resource data' do
    new_data = {
      type:          'other_bar',
      id:            'efg567',
      attributes:    {},
      relationships: {}
    }

    resource = double(:resource, included: [new_data])

    enriched_document = document.include(resource)
    expect(enriched_document.included).to eql(
      document.included + [new_data]
    )
  end

  context 'when included is not provided' do
    let(:response) do
      {
        data: {
          type:          'foobar',
          id:            'abc123',
          attributes:    {},
          relationships: {}
        }
      }
    end

    it 'defaults included to []' do
      expect(document.included).to eql([])
    end
  end
end
