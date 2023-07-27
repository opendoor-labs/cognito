# frozen_string_literal: true

require 'cognito/client'

RSpec.describe Cognito::Client do
  subject(:create_client) { described_class.create(**connection_params) }

  let(:connection)  { Cognito::Client::Connection.parse(connection_params) }
  let(:uri)         { 'http://localhost:2001'                          }
  let(:api_key)     { 'full_of_stars'                                  }
  let(:api_secret)  { 'Hal9000CanFeel'                                 }
  let(:api_version) { '2016-09-01'                                     }

  let(:connection_params) do
    {
      uri:         uri,
      api_key:     api_key,
      api_secret:  api_secret,
      api_version: api_version
    }
  end

  it 'creates a client with correct connection' do
    expect(create_client).to eql(described_class.new(connection))
  end

  context 'when creating a profile' do
    subject(:client) { described_class.new(connection) }

    let(:endpoint) { '/profiles' }

    let(:response) do
      HTTP::Response.new(version: '1.1', status: 201, body: response_body)
    end

    let(:response_body) do
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

    let(:profile_request) do
      Cognito::Client::Request.new(
        verb:     :post,
        endpoint: endpoint,
        headers:  { 'Content-Type' => 'application/vnd.api+json' },
        data:     data
      )
    end

    let(:data) do
      { data: { type: 'profile' } }
    end

    it 'builds the correct request' do
      allow(connection).to receive(:run).and_return(response)

      expect(client.create_profile).to eql(
        Cognito::Client::Response::Profile.build(response, connection)
      )
    end

    it 'successfully creates a profile' do
      allow(connection).to receive(:run).and_return(response)

      client.create_profile

      expect(connection).to have_received(:run).with(profile_request)
    end
  end

  context 'when creating a identity_search' do
    subject(:client) { described_class.new(connection) }

    let(:endpoint) { '/identity_searches' }

    let(:params) do
      { profile_id: 'oi13uaiof2qoi' }
    end

    let(:created_response) do
      HTTP::Response.new(version: '1.1', status: 202, headers: headers, body: '')
    end

    let(:headers) do
      { Location: '/identity_searches/oi13uaiof2qoi' }
    end

    let(:identity_search_request) do
      Cognito::Client::Request.new(
        verb:     :post,
        endpoint: endpoint,
        headers:  { 'Content-Type' => 'application/vnd.api+json' },
        data:     data
      )
    end

    let(:data) do
      {
        data: {
          type: 'identity_search',
          relationships: {
            profile: {
              data: {
                type: 'profile',
                id:   'oi13uaiof2qoi'
              }
            }
          },
          attributes: {
            name:  nil,
            phone: { number: nil },
            ssn: nil,
            birth: nil,
            us_address: nil
          }
        }
      }
    end

    it 'builds the correct request' do
      allow(connection).to receive(:run).and_return(created_response)

      expect(client.create_identity_search(params)).to eql(
        Cognito::Client::Response::IdentitySearchJob.build(created_response, connection, endpoint)
      )
    end

    it 'receives the correct calls' do
      allow(connection).to receive(:run).and_return(created_response)

      client.create_identity_search(params)

      expect(connection).to have_received(:run).with(identity_search_request)
    end
  end
end
