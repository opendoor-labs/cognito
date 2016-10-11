# frozen_string_literal: true

RSpec.describe Cognito::Client::Response::IdentitySearchJob do
  include_context 'response wrapper'

  let(:body)        { ''  }
  let(:status_code) { 202 }

  let(:headers) do
    { 'Content-Location' => 'some_uri' }
  end

  its(:processing?) { is_expected.to be(true) }

  it 'can command the retrieval of an identity' do
    allow(Cognito::Client::Command::RetrieveIdentitySearchJob).to receive(:call)

    response.get

    expect(Cognito::Client::Command::RetrieveIdentitySearchJob).to have_received(:call)
      .with(connection, 'some_uri')
  end
end
