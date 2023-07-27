# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Response::IdentitySearchJob do
  include_context 'response wrapper'

  subject(:response) { described_class.build(http_response, connection, location) }
  let(:body)        { ''  }
  let(:location)    { 'some_uri' }
  let(:status_code) { 202 }

  let(:headers) do
    { 'Content-Location' => location }
  end

  its(:processing?) { is_expected.to be(true) }

  it 'can command the retrieval of an identity' do
    allow(Cognito::Client::Command::RetrieveIdentitySearchJob).to receive(:call)

    response.get

    expect(Cognito::Client::Command::RetrieveIdentitySearchJob).to have_received(:call)
      .with(connection, 'some_uri')
  end
end
