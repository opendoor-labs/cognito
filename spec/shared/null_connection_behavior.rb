# frozen_string_literal: true
RSpec.shared_context 'null connection' do
  let(:connection) { instance_double(Cognito::Client::Connection) }

  let(:http_response) do
    HTTP::Response.new(
      status:  status_code,
      version: '1.1',
      headers: headers,
      body:    body
    )
  end

  before do
    allow(connection)
      .to receive(:run)
      .and_return(http_response)
  end
end
