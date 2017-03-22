# frozen_string_literal: true
#
class Cognito
  class Client
    class Command
      class CreateIdentity < self
        include Mixins::CreateBehavior,
                AbstractType,
                Anima.new(:connection, :name, :phone_number, :ssn, :birth)

        private :name, :phone_number, :ssn, :birth

        OMITTED = Params::Omitted.new

        # ignores :reek:FeatureEnvy:
        def initialize(name: OMITTED, phone_number: OMITTED, ssn: OMITTED, birth: OMITTED, **params)
          super(params.merge(name: name, phone_number: phone_number, ssn: ssn, birth: birth))
        end
      end # CreateIdentity
    end # Command
  end # Client
end # Cognito
