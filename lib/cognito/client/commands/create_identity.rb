# frozen_string_literal: true
#
class Cognito
  class Client
    class Command
      class CreateIdentity < self
        include Mixins::CreateBehavior,
                AbstractType,
                Anima.new(:connection, :name, :phone_number)

        private :name, :phone_number

        OMITTED = Params::Omitted.new

        # ignores :reek:FeatureEnvy:
        def initialize(name: OMITTED, phone_number: OMITTED, **params)
          super(params.merge(name: name, phone_number: phone_number))
        end
      end # CreateIdentity
    end # Command
  end # Client
end # Cognito
