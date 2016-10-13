# Cognito Client [![CircleCI](https://circleci.com/gh/opendoor-labs/cognito.svg?style=shield)](https://circleci.com/gh/opendoor-labs/cognito)

Unofficial Ruby client for the BlockScore Cognito API. This library was designed using a [command-query separation principle](https://en.wikipedia.org/wiki/Command–query_separation).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cognito-client', require: 'cognito'
```

And then execute:

    $ bundle

## Usage

### Creating a client

```ruby
client = Cognito::Client.create(
  api_key:     'your-api-key',
  api_secret:  'your-api-secret',
  uri:         'https://sandbox.cognitohq.com',
  api_version: '2016-09-01'
)
```

### Creating a profile

```ruby
profile = client.create_profile
```

### Create an identity search with phone and name

```ruby
search = client.create_identity_search(
  profile_id:   profile.data.id,
  phone_number: '+14151231234',
  name: { # optional
    first: 'Leslie',
    last:  'Knope'
  }
)
```

### Creating an identity assessment for the search

```ruby
assessment = search.create_assessment(
  phone_number: '+14151231234',
  name: {
    first: 'Leslie',
    last:  'Doe'
  }
)
```

### Traversing the data

The client automatically links the resource relationships allowing you to make calls like:

```ruby
search.data.identity_records.first.names.map(&:attributes)

# [
#   { :first=>"LESLIE", :middle=>"BARBARA", :last=>"KNOPE" },
#   {:first=>"LESLIE", :middle=>nil, :last=>"KNOPE-WYATT" }
# ]

```

## Running the test suite

```
bundle exec rspec
```

## Running the CI tasks

```
bundle exec rake ci
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

