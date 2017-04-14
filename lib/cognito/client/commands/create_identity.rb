# frozen_string_literal: true
#
class Cognito
  class Client
    class Command
      class CreateIdentity < self
        include Mixins::CreateBehavior,
                AbstractType,
                Anima.new(:connection, :name, :phone_number, :ssn, :birth, :us_address)

        private :name, :phone_number, :ssn, :birth, :us_address

        OMITTED = Params::Omitted.new

        # ignores :reek:FeatureEnvy:, :reek:LongParameterList:
        # rubocop:disable ParameterLists, LineLength
        def initialize(name: OMITTED, phone_number: OMITTED, ssn: OMITTED, birth: OMITTED, us_address: OMITTED, **params)
          super(params.merge(name: name, phone_number: phone_number, ssn: ssn, birth: birth, us_address: us_address))
        end
        # rubocop:enable ParameterLists, LineLength
      end # CreateIdentity
    end # Command
  end # Client
end # Cognito
