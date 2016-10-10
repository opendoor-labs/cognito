# frozen_string_literal: true

module Cognito
  class Resource
    include AbstractType,
            Memoizable,
            Anima.new(:id, :type, :attributes, :relationships, :parent)

    class MissingRelation < StandardError
      MESSAGE = "Registered relation key, '%s', not in relationships"\
                ' for resource: %p'

      def initialize(key, resource)
        super(format(MESSAGE, *[key, resource]))
      end
    end

    def self.register_type(type)
      REGISTRY.add(type, self)
    end
    private_class_method :register_type

    # ignores :reek:TooManyStatements:
    def self.one(key)
      define_relationship(key) do
        identifier = relationship_data(key)
        return unless identifier

        find_identifier(identifier)
      end
    end
    private_class_method :one

    def self.many(key)
      define_relationship(key) do
        relationship_data(key).map(&method(:find_identifier))
      end
    end
    private_class_method :many

    def self.attribute(key, method_name = key)
      define_method(method_name) do
        attributes[key]
      end
    end

    def self.define_relationship(key, &block)
      memoize(define_method(key, &block))
    end
    private_class_method :define_relationship

    def self.create(data)
      document = Document.new(data)

      build(document.data, document)
    end

    def self.build(data, parent)
      new(data.merge(parent: parent))
    end

    def include(resource)
      with(parent: parent.include(resource))
    end

    def included
      parent.included
    end

    def initialize(relationships: nil, **options)
      super
    end

    protected

    def resolve(identifier)
      parent.resolve(identifier)
    end

    private

    def find_identifier(identifier)
      resource_class = REGISTRY.lookup(identifier.fetch(:type).to_sym)
      resource_class.build(resolve(identifier), self)
    end

    def relationship_data(key)
      fail MissingRelation.new(key, self) unless relationships && relationships.key?(key)

      relationships.fetch(key).fetch(:data)
    end

    class Registry
      include Concord.new(:registry)

      class Error < StandardError
        def initialize(type)
          super(format(self.class::MESSAGE, type: type))
        end
      end

      class MissingError < Error
        MESSAGE = 'Resource type not registered: %<type>s'
      end

      class DuplicateTypeError < Error
        MESSAGE = 'Resource type already registered: %<type>s'
      end

      def initialize
        super({})
      end

      def lookup(type)
        registry.fetch(type) do
          fail MissingError, type
        end
      end

      def add(type, resource_class)
        fail DuplicateTypeError, type if registry.key?(type)

        registry[type] = resource_class
      end
    end

    REGISTRY = Registry.new
  end
end
