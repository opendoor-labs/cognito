# frozen_string_literal: true

module Cognito
  class Error < StandardError; end
  class ClientError < Error; end
  class ResourceNotFound < ClientError; end
  class ServerError < Error; end
end
