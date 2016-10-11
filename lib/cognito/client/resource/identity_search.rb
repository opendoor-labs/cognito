# frozen_string_literal: true
class Cognito
  class Client
    class Resource
      class IdentitySearch < self
        register_type :identity_search

        many :identity_records
      end # IdentitySearch

      class IdentityRecord < self
        register_type :identity_record

        many :addresses
        many :names
        many :ssns
        many :phones
        many :births
        many :deaths
      end # IdentityRecord

      class USAddress < self
        register_type :us_address

        attribute :street
        attribute :city
        attribute :subdivision
        attribute :postal_code
      end # USAddress

      class PartialName < self
        register_type :name

        attribute :first
        attribute :middle
        attribute :last
      end # PartialName

      class SSN < self
        register_type :ssn

        attribute :number
      end # SSN

      class Phone < self
        register_type :phone
      end # Phone

      class PartialDate < self
        attribute :day
        attribute :month
        attribute :year
      end # PartialDate

      class Birth < PartialDate
        register_type :birth
      end # Birth

      class Death < PartialDate
        register_type :death
      end # Death
    end # Resource
  end # Client
end # Cognito
