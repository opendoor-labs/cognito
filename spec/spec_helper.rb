# frozen_string_literal: true
require 'cognito/client'

require 'devtools/spec_helper'

RSpec.configure do |config|
  config.filter_run focus: ENV['CI'] != 'true'
  config.run_all_when_everything_filtered = true
end
