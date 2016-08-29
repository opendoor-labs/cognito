# frozen_string_literal: true

require 'json'

module Cognito
  module Responder
    def included(base)
      base.include InstanceMethods
    end

    def response_from(response)
      build(parse_response(response))
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

    def parse_response(response)
      json = JSON.parse(response.body, symbolize_names: true)
      (response.code < 400) ? json : handle_errors(json, response.code)
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
