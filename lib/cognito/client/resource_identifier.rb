# frozen_string_literal: true

class Cognito
  class Client
    class ResourceIdentifier
      include Procto.call(:to_h), Anima.new(:id, :type, :attributes, :relationships)

      def initialize(relationships: nil, **options)
        super
      end

      def to_h
        { type: type, id: id }
      end
    end # ResourceIdentifier
  end # Client
end # Cognito
