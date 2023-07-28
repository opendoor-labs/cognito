# encoding: utf-8

require 'spec_helper'

describe Adamantium::ModuleMethods, '#included' do
  subject { descendant.instance_exec(object) { |mod| include mod } }

  let(:object)     { Module.new.extend(described_class) }
  let(:descendant) { Class.new                          }
  let(:superclass) { Module                             }

  before do
    # Prevent Module.included from being called through inheritance
    allow(Adamantium).to receive(:included)
  end

  around do |example|
    # Restore included method after each example
    superclass.class_eval do
      alias_method :original_included, :included
      example.call
      undef_method :included
      alias_method :included, :original_included
    end
  end

  it 'delegates to the superclass #included method' do
    # This is the most succinct approach I could think of to test whether the
    # superclass#included method is called. All of the built-in rspec helpers
    # did not seem to work for this.
    included = 0
    superclass.class_eval { define_method(:included) { |_| included += 1 } }
    expect(included).to be(0)
    subject
    expect(included).to be(1)
  end

  it 'includes Adamantium into the descendant' do
    subject
    expect(descendant.included_modules).to include(Adamantium)
  end
end
