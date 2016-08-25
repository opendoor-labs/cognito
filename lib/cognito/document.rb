# frozen_string_literal: true

module Cognito
  class Document
    include Anima.new(:data, :included), Adamantium

    def initialize(data:, included: [])
      super
    end

    def resolve(resource_object)
      lookup.fetch(resource_object).first
    end

    def include(resource)
      with(included: included + resource.included)
    end

    private

    def lookup
      resources.group_by do |resource|
        { type: resource.fetch(:type), id: resource.fetch(:id) }
      end
    end
    memoize :lookup

    def resources
      included + [data]
    end
    memoize :resources
  end
end
