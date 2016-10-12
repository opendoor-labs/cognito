# frozen_string_literal: true
class Cognito
  class Client
    class Params
      include Procto.call(:to_h),
              AbstractType,
              Adamantium

      abstract_method :to_h
    end # Params
    private_constant(:Params)
  end # Client
end # Cognito
