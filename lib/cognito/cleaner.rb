# frozen_string_literal: true

module Cognito
  class Cleaner
    attr_accessor :response
    attr_reader :whitelist

    def initialize(response, whitelist)
      @response = response.dup
      @whitelist = whitelist
    end

    def call
      # Only do this when we have an identity_search response.
      return response unless response.key?(:included)

      cleaned_includes = included.select do |record|
        whitelist.include?(record[:type])
      end

      response.tap { |r| r[:included] = cleaned_includes }
    end

    private

    def included
      response[:included]
    end
  end
end
