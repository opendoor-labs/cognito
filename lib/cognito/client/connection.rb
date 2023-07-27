# frozen_string_literal: true
class Cognito
  class Client
    class Connection
      include Anima.new(:uri, :api_key, :api_secret, :api_version)

      def self.parse(args)
        args[:uri] ||= nil

        new(**args.merge(uri: Addressable::URI.parse(args[:uri])))
      end

      # ignores :reek:FeatureEnvy:
      def run(request)
        signed_request =
          request.sign(date: Time.now.httpdate, api_key: api_key, api_secret: api_secret)

        HTTP
          .headers(signed_request.headers.merge(version_headers))
          .request(
            signed_request.verb,
            endpoint(signed_request.endpoint),
            json: signed_request.data
          )
      end

      def endpoint(route)
        uri.join(route).to_str
      end

      private

      def version_headers
        { 'Cognito-Version' => api_version }
      end
    end # Connection
  end # Client
end # Cognito
