# frozen_string_literal: true
class Cognito
  class Client
    class Command
      include Procto.call(:run), AbstractType, Adamantium

      Failed = Class.new(StandardError)

      def run
        fail Failed, failure_reason unless success?

        present_response
      end

      private

      def failure_reason
        return response.reason if response.to_str.empty?

        response
      end

      abstract_method :present_response
      abstract_method :success?
      abstract_method :request
      abstract_method :connection

      def response
        connection.run(request)
      end
      memoize :response, freezer: :flat
    end # Command
  end # Client
end # Cognito
