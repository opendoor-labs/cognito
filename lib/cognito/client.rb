# frozen_string_literal: true

module Cognito
  class Client
    include HTTParty,
            Responder

    URI = 'https://sandbox.cognitohq.com'

    # Default URI, can be override with Client#base_uri
    base_uri URI

    def initialize(api_key:, api_secret:)
      @api_key = api_key
      @api_secret = api_secret
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

    protected

    def get(path)
      headers = notarize_request('get', path, '').headers
      response_from(self.class.get(path, headers: headers))
    end

    def post(path, payload)
      headers = notarize_request('post', path, payload).headers
      response_from(self.class.post(path, headers: headers, body: payload))
    end

    private

    def notarize_request(verb, path, body)
      target = "#{verb} #{path}"

      Notary.new(
        api_key: @api_key,
        api_secret: @api_secret,
        target: target,
        body: body
      )
    end

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
