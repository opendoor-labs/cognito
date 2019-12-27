# frozen_string_literal: true

class Cognito
  class Client
    class Command
      class RetrieveIdentitySearchJob < self
        include Concord.new(:connection, :endpoint)

        private

        def present_response
          case response.code
          when 303
            identity_resource
          when 200
            processing_response
          else
            fail Failed, response.reason
          end
        end

        def identity_resource
          RetrieveIdentityLocation.call(connection, response['Location'])
        end

        def processing_response
          Response::IdentitySearchJob.build(response, connection, endpoint)
        end

        def success?
          response.status.success? || response.status.redirect?
        end

        def request
          Request.get(endpoint)
        end
      end # RetrieveIdentitySearchJob
    end # Command
  end # Client
end # Cognito
