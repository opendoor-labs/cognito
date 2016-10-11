# frozen_string_literal: true
class Cognito
  class Client
    class Command
      module Mixins
        module CreateBehavior
          private

          def success?
            response.status.created?
          end

          def request
            Request.post(self.class::ENDPOINT, params)
          end
        end # CreateBehavior
      end # Mixins
    end # Command
  end # Client
end # Cognito
