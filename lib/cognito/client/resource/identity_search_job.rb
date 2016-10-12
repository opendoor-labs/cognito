# frozen_string_literal: true
class Cognito
  class Client
    class Resource
      class IdentitySearchJob < self
        register_type :identity_search_job

        attribute :status
      end # IdentitySearchJob
    end # Resource
  end # Client
end # Cognito
