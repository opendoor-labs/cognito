# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Command::CreateIdentityAssessment do
  include_context 'null connection'

  subject(:response) { described_class.call(params) }

  let(:status_code)  { 201            }
  let(:headers)      { {}             }
  let(:phone_number) { '+12223334444' }

  let(:params) do
    {
      connection:                 connection,
      identity_search_identifier: identity_search_identifier,
      name:                       name,
      phone_number:               phone_number
    }
  end

  let(:name) do
    { first: 'John', middle: 'Joe', last: 'Doe' }
  end

  let(:identity_search_identifier) do
    { type: 'identity_search', id: 'some_id' }
  end

  let(:body) do
    <<-JSON
    {
      "data": {
        "type": "identity_assessment",
        "id": "23iwasfoi3fu",
        "attributes": {
          "created_at": "2016-06-27T19:37:18Z",
          "name": {
            "first": "John",
            "middle": "Smith",
            "last": "Doe"
          }
        },
        "relationships": {
          "identity_record_comparisons": {
            "data": []
          }
        }
      }
    }
    JSON
  end

  context 'when search is successful' do
    let(:request) do
      Cognito::Client::Request.post(
        '/identity_assessments',
        data: {
          type: 'identity_assessment',
          relationships: {
            identity_search: {
              data: identity_search_identifier
            }
          },
          attributes: {
            name:  name,
            phone: { number: phone_number },
            ssn: nil,
            birth: nil,
            us_address: nil
          },
        }
      )
    end

    it 'constructs an assessment with provided input' do
      is_expected.to(
        eql(Cognito::Client::Response::IdentityAssessment.build(http_response, connection))
      )

      expect(connection).to have_received(:run).with(request)
    end
  end

  context 'when request uses inheritance' do
    let(:params) do
      {
        connection:                 connection,
        identity_search_identifier: identity_search_identifier
      }
    end

    let(:request) do
      Cognito::Client::Request.post(
        '/identity_assessments',
        data: {
          type:          'identity_assessment',
          relationships: {
            identity_search: {
              data: identity_search_identifier
            }
          },
          attributes: {
            name:  nil,
            phone: { number: nil },
            ssn: nil,
            birth: nil,
            us_address: nil
          },
        }
      )
    end

    it 'constructs an assessment with the http response' do
      is_expected.to(
        eql(Cognito::Client::Response::IdentityAssessment.build(http_response, connection))
      )

      expect(connection).to have_received(:run).with(request)
    end
  end

  it_behaves_like 'a properly failing command'
end
