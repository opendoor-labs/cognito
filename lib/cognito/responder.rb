# frozen_string_literal: true

require 'json'

module Cognito
  module Responder
    DEFAULT_WHITELIST = %w(
      identity_record
      birth
      death
      us_address
      name
      phone
      ssn
    ).freeze

    def included(base)
      base.include InstanceMethods
    end

    def response_from(response, options = {})
      build(parse_response(response, options))
    end

    private

    MAPPER = {
      IDENTITY_ASSESSMENT => Cognito::Resource::IdentityAssessment,
      IDENTITY_SEARCH => Cognito::Resource::IdentitySearch,
      IDENTITY_SEARCH_JOB => Cognito::Resource::IdentitySearchJob,
      PROFILE => Cognito::Resource::Profile
    }.freeze

    def build(json)
      klass_mapper(json.dig(:data, :type)).create(json)
    end

    def klass_mapper(type)
      MAPPER.fetch(type) { raise ServerError, 'malformed JSON response' }
    end

    def parse_response(response, options = {})
      json = JSON.parse(response.body, symbolize_names: true)
      if response.code < 400
        whitelist = options.fetch(:permit, DEFAULT_WHITELIST).map(&:to_s)
        Cleaner.new(json, whitelist).call
      else
        handle_errors(json, response.code)
      end
    end

    def handle_errors(json, code)
      klass = (code < 500) ? ClientError : ServerError
      format_error(klass, json[:errors].first)
    end

    def format_error(klass, error)
      raise klass, error[:detail]
    end
  end
end
