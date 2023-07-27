# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Response::IdentitySearch do
  include_context 'response wrapper'

  let(:status_code) { 200 }
  let(:headers)     { {}  }

  context 'when assessment attributes are provided' do
    let(:body) do
      <<-JSON
        {
          "data": {
            "type":          "identity_search",
            "id":            "o3irufoai3o",
            "attributes":    {
              "name": {
                "first": "John",
                "last": "Doe"
              },
              "phone": {
                "number": "+12223334444"
              }
            },
            "relationships": {
              "identity_records": {
                "data": []
              }
            }
          }
        }
      JSON
    end

    its(:processing?) { is_expected.to be(false) }

    it 'can command the creation of an identity_assessment' do
      allow(Cognito::Client::Command::CreateIdentityAssessment).to receive(:call)

      response.create_assessment(
        name:         { first: 'John', last: 'Doe' },
        phone_number: '+12223334444'
      )

      expect(Cognito::Client::Command::CreateIdentityAssessment).to have_received(:call)
        .with(
          connection:                 connection,
          name:                       { first: 'John', last: 'Doe' },
          phone_number:               '+12223334444',
          identity_search_identifier: {
            type: 'identity_search',
            id:   'o3irufoai3o'
          }
        )
    end
  end

  context 'when no assessment attributes are provided' do
    let(:body) do
      <<-JSON
        {
          "data": {
            "type":          "identity_search",
            "id":            "o3irufoai3o",
            "attributes":    {},
            "relationships": {
              "identity_records": {
                "data": []
              }
            }
          }
        }
      JSON
    end

    its(:processing?) { is_expected.to be(false) }

    it 'can command the creation of an identity_assessment' do
      allow(Cognito::Client::Command::CreateIdentityAssessment).to receive(:call)

      response.create_assessment

      expect(Cognito::Client::Command::CreateIdentityAssessment).to have_received(:call)
        .with(
          connection:                 connection,
          identity_search_identifier: {
            type: 'identity_search',
            id:   'o3irufoai3o'
          }
        )
    end
  end
end
