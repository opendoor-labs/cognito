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

    class USAddress < self
      register_type :us_address

      attribute :street
      attribute :city
      attribute :subdivision
      attribute :postal_code
    end

    class Name < self
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

      attribute :number
    end

    class Birth < self
      register_type :birth

      attribute :day
      attribute :month
      attribute :year
    end

    class Death < self
      register_type :death

      attribute :day
      attribute :month
      attribute :year
    end
  end
end
