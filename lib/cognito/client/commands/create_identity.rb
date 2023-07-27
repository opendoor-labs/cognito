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
        def initialize(args = {})
          dup_args = args.dup
          # dup_args[:name] ||= nil
          # dup_args[:phone_number] ||= nil
          # dup_args[:ssn] ||= nil
          # dup_args[:birth] ||= nil
          # dup_args[:us_address] ||= nil
          super(
            dup_args.merge(
              name: dup_args[:name],
              phone_number: dup_args[:phone_number],
              ssn: dup_args[:ssn],
              birth: dup_args[:birth],
              us_address: dup_args[:us_address]
            )
          )
        end
        # rubocop:enable ParameterLists, LineLength
      end # CreateIdentity
    end # Command
  end # Client
end # Cognito
