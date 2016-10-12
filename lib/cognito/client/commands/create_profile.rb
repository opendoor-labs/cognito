# frozen_string_literal: true
class Cognito
  class Client
    class Command
      class CreateProfile < self
        include Mixins::CreateBehavior, Concord.new(:connection)

        ENDPOINT = '/profiles'
        PARAMS   = IceNine.deep_freeze(data: { type: 'profile' })

        private

        def present_response
          Response::Profile.build(response, connection)
        end

        # ignores :reek:UtilityFunction:
        def params
          PARAMS
        end
      end # CreateProfile
    end # Command
  end # Client
end # Cognito
