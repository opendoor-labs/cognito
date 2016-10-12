# frozen_string_literal: true

class Cognito
  class Client
    class Response
      class Builder
        include Concord.new(:response), Procto.call(:to_h), Adamantium

        def to_h
          {
            status:  build_status,
            headers: response.headers.to_hash,
            data:    build_data
          }
        end

        private

        def build_data
          return if response.body.empty?

          resource_class.build(document.data, document)
        end

        def build_status
          Status.new(
            code:   response.code,
            reason: response.reason
          )
        end

        def resource_class
          data = parsed_response.fetch(:data)
          Resource::REGISTRY.lookup(data.fetch(:type).to_sym)
        end

        def document
          Document.new(parsed_response)
        end

        def parsed_response
          JSON.parse(response, symbolize_names: true)
        end
        memoize :parsed_response
      end # Builder
    end # Response
  end # Client
end # Cognito
