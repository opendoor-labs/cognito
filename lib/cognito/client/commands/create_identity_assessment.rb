# frozen_string_literal: true
class Cognito
  class Client
    class Command
      class CreateIdentityAssessment < CreateIdentity
        include Mixins::CreateBehavior, anima.add(:identity_search_identifier)

        ENDPOINT = '/identity_assessments'

        private

        def params
          Params::IdentityAssessment.call(
            identity_search_identifier: identity_search_identifier,
            name:                       name,
            phone_number:               phone_number,
            ssn:                        ssn,
            birth:                      birth,
            us_address:                 us_address
          )
        end

        def present_response
          Response::IdentityAssessment.build(response, connection)
        end
      end # CreateIdentityAssessment
    end # Command
  end # Client
end # Cognito
