# frozen_string_literal: true

module Cognito
  # Signs Cognito requests.
  class Notary
    include Anima.new(:api_key, :api_secret, :body, :target)

    CONTENT_TYPE = ACCEPT_TYPE = 'application/vnd.api+json'
    COGNITO_VERSION = '2016-09-01'

    def headers
      @headers ||= {
        'Date' => date,
        'Digest' => digest,
        'Authorization' => authorization,
        'Content-Type' => CONTENT_TYPE,
        'Accept' => ACCEPT_TYPE,
        'Cognito-Version' => COGNITO_VERSION
      }
    end

    def authorization
      @authorization ||= [
        'Signature keyId="' + api_key + '"',
        'algorithm="hmac-sha256"',
        'headers="date digest (request-target)"',
        'signature="' + signature + '"'
      ].join(',')
    end

    def digest
      @digest ||=
        "SHA-256=#{Base64.strict_encode64(Digest::SHA256.digest(body))}"
    end

    def date
      @date ||= Time.now.httpdate
    end

    def signature
      @signature ||= Base64.strict_encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::SHA256.new, api_secret, signing_string
        )
      )
    end

    def signing_string
      @signing_string ||= [
        "date: #{date}",
        "digest: #{digest}",
        "(request-target): #{target}"
      ].join("\n")
    end
  end
end
