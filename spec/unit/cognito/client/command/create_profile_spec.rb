# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Command::CreateProfile do
  include_context 'null connection'

  subject(:response) { described_class.call(connection) }

  let(:status_code) { 201 }
  let(:headers)     { {}  }

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

  context 'when request is successful' do
    let(:request) do
      Cognito::Client::Request.post('/profiles', data: { type: 'profile' })
    end

    it 'constructs a profile with the http response' do
      is_expected.to eql(Cognito::Client::Response::Profile.build(http_response, connection))

      expect(connection).to have_received(:run).with(request)
    end
  end

  it_behaves_like 'a properly failing command'
end
