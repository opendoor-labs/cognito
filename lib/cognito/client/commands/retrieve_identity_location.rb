# frozen_string_literal: true
class Cognito
  class Client
    class Command
      class RetrieveIdentityLocation < self
        include Concord.new(:connection, :endpoint)

        private

        def present_response
          identity_resource
        end

        def identity_resource
          Response::IdentitySearch.build(response, connection)
        end

        def success?
          response.code.equal?(200)
        end

        def request
          Request.get(endpoint)
        end
      end # RetrieveIdentityLocation
    end # Command
  end # Client
end # Cognito
