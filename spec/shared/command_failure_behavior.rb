# frozen_string_literal: true

RSpec.shared_examples 'a properly failing command' do
  include_context 'null connection'

  context 'when request is unsuccessful and the body is empty' do
    let(:status_code) { 400 }
    let(:body)        { ''  }

    it 'fails with "Bad Request"' do
      expect { response }.to raise_error(Cognito::Client::Command::Failed, 'Bad Request')
    end
  end

  context 'when request is unsuccessful and includes a body' do
    let(:status_code) { 400                                                 }
    let(:body)        { 'When there is a body it becomes the error message' }

    it 'has the body in the raised error message' do
      expect { response }.to raise_error(Cognito::Client::Command::Failed, body)
    end
  end
end
