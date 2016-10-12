# frozen_string_literal: true

class Cognito
  class Client
    class Response
      class IdentitySearchJob < self
        def get
          Command::RetrieveIdentitySearchJob.call(
            connection,
            headers.fetch('Content-Location')
          )
        end

        def processing?
          true
        end
      end # IdentitySearchJob
    end # Response
  end # Client
end # Cognito
