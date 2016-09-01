# frozen_string_literal: true

module Cognito
  class Client
    include HTTParty,
            Responder

    URI = 'https://sandbox.cognitohq.com'.freeze
    JSON_HEADER = 'application/vnd.api+json'.freeze
    COGNITO_VERSION = '2016-09-01'.freeze
    HEADERS = {
      'Accept' => JSON_HEADER,
      'Content-Type' => JSON_HEADER,
      'Cognito-Version' => COGNITO_VERSION,
    }.freeze

    # Default URI, can be override with Client#base_uri
    base_uri URI

    def initialize(api_key:)
      basic_auth(api_key)
    end

    def base_uri=(uri)
      self.class.base_uri(uri)
    end

    def create_profile!
      post('/profiles', profile_params.to_json)
    end

    def search!(profile_id, phone_number)
      payload = search_params(profile_id, phone_number).to_json
      post('/identity_searches', payload)
    end

    def search_status!(search_job_id)
      get("/identity_searches/jobs/#{search_job_id}")
    end

    def basic_auth(api_key)
      self.class.basic_auth(api_key, '')
    end

    protected

    def get(path)
      response_from(self.class.get(path, headers: HEADERS))
    end

    def post(path, payload)
      response_from(self.class.post(path, headers: HEADERS, body: payload))
    end

    private

    def profile_params
      {
        data: {
          type: PROFILE
        }
      }
    end

    # rubocop:disable Metrics/MethodLength
    def search_params(profile_id, phone_number)
      {
        data: {
          type: IDENTITY_SEARCH,
          attributes: {
            phone: {
              number: phone_number
            }
          },
          relationships: {
            profile: {
              data: {
                type: PROFILE,
                id:   profile_id
              }
            }
          }
        }
      }
    end
  end
end
