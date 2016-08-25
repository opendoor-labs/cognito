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
      many :dates_of_birth
      many :dates_of_death
    end

    class PartialAddressUS < self
      register_type :partial_address_us

      attribute :street
      attribute :city
      attribute :subdivision
      attribute :postal_code
    end

    class PartialName < self
      register_type :partial_name

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

      attribute :number
    end

    class PartialDate < self
      register_type :partial_date

      attribute :day
      attribute :month
      attribute :year
    end
  end
end
