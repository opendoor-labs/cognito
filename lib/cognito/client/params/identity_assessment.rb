# frozen_string_literal: true

class Cognito
  class Client
    class Params
      class IdentityAssessment < Identity
        include anima.add(:identity_search_identifier)

        TYPE = 'identity_assessment'

        private

        def relationships
          {
            identity_search: {
              data: identity_search_identifier
            }
          }
        end
      end # IdentityAssessment
    end # Params
  end # Client
end # Cognito
