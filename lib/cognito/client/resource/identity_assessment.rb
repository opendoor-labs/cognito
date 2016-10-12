# frozen_string_literal: true
class Cognito
  class Client
    class Resource
      class IdentityAssessment < self
        register_type :identity_assessment

        attribute :name
        attribute :phone

        many :identity_record_comparisons
      end # IdentityAssessment

      class IdentityRecordComparison < self
        register_type :identity_record_comparison

        many :name_comparisons
        many :phone_comparisons
        one :identity_record

        attribute :score
      end # IdentityRecordComparison

      class PhoneComparison < self
        register_type :phone_comparison

        attribute :score

        one :source_record
      end # PhoneComparison

      class NameComparison < self
        register_type :name_comparison

        attribute :score

        one :source_record

        class Components
          include Anima.new(:first, :middle, :last), Adamantium

          class Component
            include Anima.new(:source, :input, :score)

            class Name
              include Concord.new(:name), Adamantium
            end # Name
          end # Component
        end # Components
      end # NameComparison
    end # Resource
  end # Client
end # Cognito
