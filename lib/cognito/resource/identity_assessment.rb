# frozen_string_literal: true

module Cognito
  class Resource
    class IdentityAssessment < self
      register_type :identity_assessment

      attribute :name
      attribute :phone

      many :identity_record_comparisons
    end

    class IdentityRecordComparison < self
      register_type :identity_record_comparison

      many :name_comparisons
      many :phone_comparisons
      one :identity_record

      attribute :score
    end

    class PhoneComparison < self
      register_type :phone_comparison

      attribute :score

      one :source_record
    end

    class NameComparison < self
      register_type :name_comparison

      attribute :score

      one :source_record
    end
  end
end
