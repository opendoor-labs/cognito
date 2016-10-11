# frozen_string_literal: true
RSpec.shared_context 'response wrapper' do
  subject(:response) { described_class.build(http_response, connection) }

  let(:connection) { instance_double(Cognito::Client::Connection) }

  let(:http_response) do
    HTTP::Response.new(
      status:  status_code,
      version: '1.1',
      headers: headers,
      body:    body
    )
  end
end
