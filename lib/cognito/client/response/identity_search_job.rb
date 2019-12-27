# frozen_string_literal: true

class Cognito
  class Client
    class Response
      class IdentitySearchJob < self
        def self.build(response, connection, endpoint)
          identity_search_job =
            new(Builder.call(response).merge(connection: connection))
          identity_search_job.endpoint = endpoint
          identity_search_job
        end

        def get
          Command::RetrieveIdentitySearchJob.call(
            connection,
            endpoint
          )
        end

        def processing?
          true
        end

        attr_accessor :endpoint
      end # IdentitySearchJob
    end # Response
  end # Client
end # Cognito
