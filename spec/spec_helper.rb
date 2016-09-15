# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'cognito'
require 'timecop'

# Require helper files.
Dir[File.join(File.dirname(__FILE__), '/support/**/*.rb')].each do |file|
  require file
end

module Cognito
  RSpec.configure do |config|
    # Use verifying doubles.
    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = true
    end

    # Stops exposing DSL globally, disabled `should` and `should_not` syntax,
    # and disables `stub`, `should_receive`, and `should_not_receive` syntax
    # for rspec-mocks.
    config.disable_monkey_patching!

    # Display all of the details if we are only running one file.
    config.default_formatter = 'doc' if config.files_to_run.one?

    # Profile the 10 slowest examples.
    config.profile_examples = 10

    config.order = :random
    Kernel.srand config.seed
  end
end
