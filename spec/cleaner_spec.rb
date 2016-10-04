# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Cleaner do
  describe '#call' do
    let(:whitelisted) { %w(identity_record partial_name phone) }
    let(:excluded) { %w(snn partial_date) }
    let(:json) do
      JSON.parse(FileHelper.read_file(:identity_search), symbolize_names: true)
    end

    subject(:cleaned_json) { described_class.new(json, whitelisted).call }

    let(:cleaned_includes) { cleaned_json[:included] }

    it 'includes whitelisted values' do
      cleaned_includes.each do |record|
        expect(whitelisted).to include(record[:type])
      end
    end

    it 'excludes non-whitelisted values' do
      cleaned_includes.each do |record|
        expect(excluded).not_to include(record[:type])
      end
    end
  end
end
