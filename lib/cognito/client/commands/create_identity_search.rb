# frozen_string_literal: true
class Cognito
  class Client
    class Command
      class CreateIdentitySearch < CreateIdentity
        include Mixins::CreateBehavior, anima.add(:profile_id)

        private :profile_id, :name, :phone_number, :ssn, :birth, :us_address

        ENDPOINT = '/identity_searches'

        private

        def params
          Params::IdentitySearch.call(
            profile_id:   profile_id,
            name:         name,
            phone_number: phone_number,
            ssn:          ssn,
            birth:        birth,
            us_address:   us_address
          )
        end

        def present_response
          case response.code
          when 202
            Response::IdentitySearchJob.build(response, connection)
          when 201
            Response::IdentitySearch.build(response, connection)
          end
        end

        def success?
          response.status.accepted? || response.status.created?
        end
      end # CreateIdentitySearch
    end # Command
  end # Client
end # Cognito
