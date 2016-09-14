# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Notary do
  describe '#initialize' do
    let(:api_key) { 'foo' }
    let(:api_secret) { 'bar' }
    let(:target) { 'post /profiles' }
    let(:body) { JSON.generate(foo: 'bar') }

    it 'requires api_key' do
      expect {
        described_class.new(api_secret: api_secret, target: target, body: body)
      }.to raise_exception(ArgumentError, 'missing keyword: api_key')
    end

    it 'requires api_secret' do
      expect {
        described_class.new(api_key: api_key, target: target, body: body)
      }.to raise_exception(ArgumentError, 'missing keyword: api_secret')
    end

    it 'requires body' do
      expect {
        described_class.new(
          api_key: api_key,
          api_secret: api_secret,
          target: target
        )
      }.to raise_exception(ArgumentError, 'missing keyword: body')
    end

    it 'requires target' do
      expect {
        described_class.new(
          api_key: api_key,
          api_secret: api_secret,
          body: body
        )
      }.to raise_exception(ArgumentError, 'missing keyword: target')
    end
  end
end
