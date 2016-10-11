# frozen_string_literal: true
RSpec.shared_examples 'a command with an unexpected response code' do
  it 'fails with status reason' do
    expect { response }.to raise_error(Cognito::Client::Command::Failed, status_reason)
  end
end
