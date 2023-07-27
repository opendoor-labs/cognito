# frozen_string_literal: true
class Cognito
  class Client
    class Document
      include Anima.new(:data, :included), Adamantium

      def initialize(args = {})
        raise ArgumentError, 'data is required' unless args.key?(:data)

        dup_args = args.dup
        dup_args[:included] ||= []

        super(dup_args)
      end

      def resolve(resource_object)
        lookup.fetch(resource_object).first
      end

      def include(resource)
        with(included: included + resource.included)
      end

      private

      def lookup
        resources.group_by(&ResourceIdentifier)
      end
      memoize(:lookup)

      def resources
        included + [data]
      end
      memoize :resources
    end # Document
  end # Client
end # Cognito
