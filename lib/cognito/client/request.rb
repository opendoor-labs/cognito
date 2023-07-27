# frozen_string_literal: true
class Cognito
  class Client
    class Request
      CONSTANT_HEADERS = IceNine.deep_freeze(
        'Content-Type' => 'application/vnd.api+json'
      )

      include Anima.new(:verb, :endpoint, :data, :headers), Adamantium

      def self.post(*arguments)
        build(:post, *arguments)
      end

      def self.get(endpoint)
        build(:get, endpoint, nil)
      end

      def self.build(verb, endpoint, data)
        new(
          verb:     verb,
          endpoint: endpoint,
          data:     data,
          headers:  CONSTANT_HEADERS
        )
      end
      private_class_method :build

      def sign(signature_params)
        with(headers: SigningHeaders.call(request: self, **signature_params))
      end

      class SigningHeaders
        include Procto.call(:to_h), Anima.new(:request, :date, :api_key, :api_secret), Adamantium

        DIGEST_HEADER = 'SHA-256=%<digest>s'
        EMPTY_BODY    = ''
        SHA256        = IceNine.deep_freeze(OpenSSL::Digest::SHA256.new)

        AUTHORIZATION_STRING = [
          'Signature keyId="%<api_key>s"',
          'algorithm="hmac-sha256"',
          'headers="date digest (request-target)"',
          'signature="%<signature>s"'
        ].join(',').freeze

        SIGNING_STRING = [
          'date: %<date>s',
          'digest: %<digest>s',
          '(request-target): %<request_target>s'
        ].join("\n").freeze

        def to_h
          request.headers.merge(
            'Authorization' => auth_header,
            'Digest'        => digest_header,
            'Date'          => date
          )
        end

        private

        def auth_header
          format(AUTHORIZATION_STRING, api_key: api_key, signature: signature)
        end

        def signature
          Base64.strict_encode64(OpenSSL::HMAC.digest(SHA256, api_secret, signing_string))
        end

        def signing_string
          format(SIGNING_STRING, date: date, digest: digest_header, request_target: request_target)
        end

        def digest_header
          format(DIGEST_HEADER, digest: digest)
        end

        def request_target
          "#{request.verb} #{request.endpoint}"
        end

        def digest
          Base64.strict_encode64(SHA256.digest(request_body))
        end
        memoize :digest

        def request_body
          return EMPTY_BODY unless request.data

          JSON.dump(request.data)
        end

        private_constant(*constants(false))
      end # SigningHeaders
    end # Request
  end # Client
end # Cognito
