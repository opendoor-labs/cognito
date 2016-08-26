# frozen_string_literal: true

module Cognito
  class Client
    include HTTParty

    class ResourceNotFound < StandardError; end

    # Default URI, can be override with Client#base_uri
    base_uri 'https://sandbox.cognitohq.com'

    HEADERS = {
      'Accept' => 'application/vnd.api+json',
      'Content-Type' => 'application/vnd.api+json'
    }.freeze

    def initialize(api_key:)
      basic_auth(api_key)
    end

    def base_uri=(uri)
      self.class.base_uri(uri)
    end

    def create_profile!
      response = post('/profiles', profile_params.to_json)

      json = JSON.parse(response.body, symbolize_names: true)
      Cognito::Resource::Profile.create(json)
    end

    def search!(profile_id, phone_number)
      payload = search_params(profile_id, phone_number).to_json
      response = post('/identity_searches', payload)

      json = JSON.parse(response.body, symbolize_names: true)
      if response.code == 201
        Cognito::Resource::IdentitySearch.create(json)
      elsif response.code == 202
        Cognito::Resource::IdentitySearchJob.create(json)
      end
    end

    def search_status!(search_job_id)
      response = get("/identity_searches/jobs/#{search_job_id}")

      json = JSON.parse(response.body, symbolize_names: true)
      Cognito::Resource::IdentitySearchJob.create(json)
    end

    def basic_auth(api_key)
      self.class.basic_auth(api_key, '')
    end

    protected

    def get(path)
      self.class.get(path, headers: HEADERS)
    end

    def post(path, payload)
      self.class.post(path, headers: HEADERS, body: payload)
    end

    private

    def profile_params
      {
        data: {
          type: 'profile'
        }
      }
    end

    # rubocop:disable Metrics/MethodLength
    def search_params(profile_id, phone_number)
      {
        data: {
          type: 'identity_search',
          attributes: {
            phone: {
              number: phone_number
            }
          },
          relationships: {
            profile: {
              data: {
                type: 'profile',
                id:   profile_id
              }
            }
          }
        }
      }
    end
  end
end
