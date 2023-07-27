# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Response do
  include_context 'response wrapper'

  subject(:processing_response) { described_class.build(http_response, connection) }

  let(:created_response) do
    described_class.new(
      status:     described_class::Status.new(code: 201, reason: 'Created'),
      headers:    headers,
      data:       nil,
      connection: connection,
      json:       nil
    )
  end

  let(:status_code) { 201 }

  let(:headers) do
    { 'Location' => 'some_uri' }
  end

  context 'when no response body is provided' do
    let(:body) { '' }

    it 'builds a proper response when no data' do
      is_expected.to eql(created_response)
    end
  end

  context 'when a response body is present' do
    let(:body) do
      <<-JSON
      {
        "data": {
          "type": "profile",
          "id": "oi13uaiof2qoi",
          "attributes": {
            "created_at": "2016-04-01T13:59:59.438Z"
          },
          "relationships": {}
        }
      }
      JSON
    end

    it 'parses and builds data into a resource for the response' do
      document = Cognito::Client::Document.new(
        data: {
          type:          'profile',
          id:            'oi13uaiof2qoi',
          attributes:    {
            created_at: '2016-04-01T13:59:59.438Z'
          },
          relationships: {}
        }
      )

      is_expected.to eql(
        created_response.with(
          data: Cognito::Client::Resource::Profile.build(document.data, document),
          json: JSON.parse(body)
        )
      )
    end
  end
end
