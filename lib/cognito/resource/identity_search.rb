# frozen_string_literal: true

module Cognito
  class Resource
    class IdentitySearch < self
      register_type :identity_search

      many :identity_records
    end

    class IdentityRecord < self
      register_type :identity_record

      many :addresses
      many :names
      many :ssns
      many :phones
      many :births
      many :deaths
    end

    class USAddress < self
      register_type :us_address

      attribute :street
      attribute :city
      attribute :subdivision
      attribute :postal_code
    end

    class PartialName < self
      register_type :name

      attribute :first
      attribute :middle
      attribute :last
    end

    class SSN < self
      register_type :ssn

      attribute :number
    end

    class Phone < self
      register_type :phone
    end

    class PartialDate < self
      attribute :day
      attribute :month
      attribute :year
    end

    class Birth < PartialDate
      register_type :birth
    end

    class Death < PartialDate
      register_type :death
    end
  end
end
