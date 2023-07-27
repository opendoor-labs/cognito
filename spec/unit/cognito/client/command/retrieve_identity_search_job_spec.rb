# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Command::RetrieveIdentitySearchJob do
  include_context 'null connection'

  subject(:response) { described_class.call(connection, location) }

  let(:location) { '/identity_searches/jobs/foi2uoiaf' }
  let(:request)  { Cognito::Client::Request.get(location) }
  let(:headers)  { {}                                  }
  let(:body)     { ''                                  }

  context 'when response is completed' do
    let(:redirect_location) { '/identity_searches/fd54efc4d' }
    let(:status_code)       { 303                            }
    let(:body)              { 'It should not matter'         }

    let(:headers) do
      { 'Location' => redirect_location }
    end

    it 'receives call with the correct params' do
      allow(Cognito::Client::Command::RetrieveIdentityLocation).to receive(:call)

      response

      expect(Cognito::Client::Command::RetrieveIdentityLocation).to have_received(:call)
        .with(connection, redirect_location)
    end

    it 'build the identity_search response' do
      allow(Cognito::Client::Command::RetrieveIdentityLocation).to receive(:call)

      response

      expect(connection).to have_received(:run).with(request)
    end
  end

  context 'when response is processing' do
    let(:status_code) { 200 }

    let(:body) do
      <<-JSON
        {
          "data": {
            "type": "identity_search_job",
            "id": "foi2uoiaf",
            "attributes": {
              "created_at": "2016-07-18T21:24:18.00Z",
              "status": "processing"
            },
            "relationships": {
              "identity_search": null
            }
          }
        }
      JSON
    end

    it 'receives run with the correct params' do
      is_expected.to eql(
        Cognito::Client::Response::IdentitySearchJob.build(http_response, connection, location)
      )

      expect(connection).to have_received(:run).with(request)
    end

    it 'returns a processing identity_search response' do
      is_expected.to eql(
        Cognito::Client::Response::IdentitySearchJob.build(http_response, connection, location)
      )

      expect(response.data.status).to eql('processing')
      expect(response.endpoint).to eql location
    end

    context 'BUG: builds an IdentitySearchJob which expects a `Content-Location` header' do
      it 'does not raise error for missing `Content-Location` header' do
        is_expected.to eql(
          Cognito::Client::Response::IdentitySearchJob.build(http_response, connection, location)
        )
        allow(Cognito::Client::Command::RetrieveIdentitySearchJob).to receive(:call)
        expect do
          response.get
        end.to_not raise_error KeyError, /Content-Location/
      end
    end
  end

  it_behaves_like 'a command with an unexpected response code' do
    let(:status_code)   { 204          }
    let(:status_reason) { 'No Content' }
  end

  it_behaves_like 'a properly failing command'
end
