# frozen_string_literal: true

class Cognito
  class Client
    class Response
      class IdentitySearch < self
        def create_assessment(attributes = {})
          Command::CreateIdentityAssessment.call(
            attributes.merge(
              connection:                 connection,
              identity_search_identifier: identifier
            )
          )
        end

        def processing?
          false
        end

        private

        def identifier
          ResourceIdentifier.call(data_without_parent)
        end

        def data_without_parent
          data.to_h.reject { |key| key.equal?(:parent) }
        end
      end # IdentitySearch
    end # Response
  end # Client
end # Cognito
