# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Command::RetrieveIdentityLocation do
  include_context 'null connection'

  subject(:response) { described_class.call(connection, location) }

  let(:location)    { '/identity_searches/abc123'        }
  let(:status_code) { 200                                }
  let(:body)        { ''                                 }
  let(:headers)     { {}                                 }
  let(:request)     { Cognito::Client::Request.get(location) }

  context 'when response is completed' do
    let(:body) do
      <<-JSON
        {
          "data": {
            "type": "identity_search",
            "id": "o3irufoai3o",
            "attributes": {
              "created_at": "2016-06-27T19:37:18Z",
              "phone": {
                "number": "+16508007985"
              }
            },
            "relationships": {
              "profile": {
                "data": {
                  "type": "profile",
                  "id": "oi13uaiof2qoi"
                }
              },
              "identity_records": {
                "data": []
              }
            }
          },
          "included": []
        }
      JSON
    end

    it 'build the identity_search response' do
      is_expected.to eql(Cognito::Client::Response::IdentitySearch.build(http_response, connection))

      expect(connection).to have_received(:run).with(request)
    end
  end

  it_behaves_like 'a command with an unexpected response code' do
    let(:status_code)   { 204          }
    let(:status_reason) { 'No Content' }
  end
end
