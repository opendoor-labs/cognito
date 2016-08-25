# Cognito

Ruby client for the BlockScore Cognito API.

Frankenstein of demo code supplied by BlockScore, and our own stuff. `client.rb` is ours,
everything else is theirs. The BlockScore code basically just handles the structuring
of their data models.

Currently in the "make it work" phase of development.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cognito'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cognito

## Usage

Create a client

```ruby
client = Cognito::Client.new(api_key: 'SOME_API_KEY')

# default base URI is https://sandbox.cognitohq.com
#
# to set a different API:
client.base_uri('SOME_NEW_BASE_URI')
```

Create a Profile:

```ruby
profile = client.create_profile!
```

Initiate a search against a phone number:

```ruby
profile = client.create_profile!

search = client.search!(profile.id, '+14151231234')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cognito.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

