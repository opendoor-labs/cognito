# frozen_string_literal: true

module Cognito
  class Resource
    class IdentitySearchJob < self
      register_type :identity_search_job

      attribute :status
    end
  end
end
