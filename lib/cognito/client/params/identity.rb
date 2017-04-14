# frozen_string_literal: true

class Cognito
  class Client
    class Params
      class Identity < self
        include AbstractType, Anima.new(:name, :phone_number, :ssn, :birth, :us_address)

        abstract_method :relationships

        def to_h
          relationship_params.tap do |params|
            params[:data][:attributes] = attributes unless attributes.empty?
          end
        end

        def relationship_params
          {
            data: {
              type:          self.class::TYPE,
              relationships: relationships
            }
          }
        end

        private

        def attributes
          full_attributes.reject { |_, val| val.instance_of?(Omitted) }
        end
        memoize :attributes

        def full_attributes
          {
            name:       name,
            phone:      phone,
            ssn:        ssn,
            birth:      birth,
            us_address: us_address
          }
        end

        def phone
          return phone_number if phone_number.instance_of?(Omitted)

          { number: phone_number }
        end
      end # Identity
    end # Params
  end # Client
end # Cognito
