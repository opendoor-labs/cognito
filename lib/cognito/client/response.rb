# frozen_string_literal: true

class Cognito
  class Client
    class Response
      include Anima.new(:status, :headers, :data, :connection)

      def self.build(response, connection)
        new(Builder.call(response).merge(connection: connection))
      end

      class Status
        include Anima.new(:code, :reason)
      end # Status
    end # Response
  end # Client
end # Cognito
