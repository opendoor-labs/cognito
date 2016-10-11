# frozen_string_literal: true
source 'https://rubygems.org'

# Specify your gem's dependencies in cognito.gemspec
gemspec

group(:tools) do
  # mutation testing tool for ruby
  gem 'mutant',       '~> 0.8.10'

  # Rspec integration for mutant
  gem 'mutant-rspec', '~> 0.8.8'

  # Watches file system and invokes commands according to mapping rules
  gem 'guard',        '~> 2.14.0'

  # Plugin to guard for RSpec tooling
  gem 'guard-rspec',  '~> 4.7.2'

  # A metagem wrapping development tools:
  #   procto,
  #   adamantium,
  #   anima,
  #   concord,
  #   rspec, rspec-core, rspec-its
  #   rake,
  #   yard,
  #   flog,
  #   flay,
  #   reek,
  #   rubocop,
  #   simplecov,
  #   yardstick,
  #   mutant, mutant-rspec
  gem 'devtools', '~> 0.1.8'

  # Rubocop extensions which reflect BlockScore's style guide
  gem 'rubocop-devtools', git: 'https://github.com/backus/rubocop-devtools.git'

  # Enforce style and convention for rspec
  gem 'rubocop-rspec', git: 'https://github.com/nevir/rubocop-rspec.git'
end
