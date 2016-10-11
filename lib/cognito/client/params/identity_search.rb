# frozen_string_literal: true

class Cognito
  class Client
    class Params
      class IdentitySearch < Identity
        include anima.add(:profile_id)

        TYPE              = 'identity_search'
        RELATIONSHIP_TYPE = 'profile'

        def relationships
          {
            profile: {
              data: {
                type: RELATIONSHIP_TYPE,
                id:   profile_id
              }
            }
          }
        end
      end # IdentitySearch
    end # Params
  end # Client
end # Cognito
