# frozen_string_literal: true
require 'concord'
require 'anima'
require 'procto'
require 'adamantium'
require 'abstract_type'
require 'http'
require 'addressable'
require 'openssl'
require 'base64'

require 'cognito/client/connection'
require 'cognito/client/request'
require 'cognito/client/document'
require 'cognito/client/resource_identifier'

# resources
require 'cognito/client/resource'
require 'cognito/client/resource/profile'
require 'cognito/client/resource/identity_search'
require 'cognito/client/resource/identity_search_job'
require 'cognito/client/resource/identity_assessment'

# responses
require 'cognito/client/response'
require 'cognito/client/response/builder'
require 'cognito/client/response/profile'
require 'cognito/client/response/identity_assessment'
require 'cognito/client/response/identity_search'
require 'cognito/client/response/identity_search_job'

# params
require 'cognito/client/params'
require 'cognito/client/params/omitted'
require 'cognito/client/params/identity'
require 'cognito/client/params/identity_assessment'
require 'cognito/client/params/identity_search'

# commands
require 'cognito/client/command'
require 'cognito/client/commands/mixins/create_behavior'
require 'cognito/client/commands/create_profile'
require 'cognito/client/commands/create_identity'
require 'cognito/client/commands/create_identity_assessment'
require 'cognito/client/commands/create_identity_search'
require 'cognito/client/commands/retrieve_identity_search_job'
require 'cognito/client/commands/retrieve_identity_location'

class Cognito
  class Client
    include Concord.new(:server)

    def self.create(connection_params)
      new(Connection.parse(**connection_params))
    end

    def create_profile
      Command::CreateProfile.call(server)
    end

    def create_identity_search(params)
      Command::CreateIdentitySearch.call(**params.merge(connection: server))
    end
  end # Client
end # Cognito
