# GeoFaker

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geo_faker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geo_faker

## Usage

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Running the demo

This repository includes a demo server which helps visualizing the results of the different actions provided by GeoFaker.

After installing all the dependencies, run

   $ bundle exec ruby demo/demo.rb

This will start a sinatra server locally on port 4567.
You can now visit URLs like http://localhost:4567/around?q=Paris.

See `demo/demo.rb` for available methods.
They generally correspond to one public `GeoFaker` method and pass the query parameters along to that method.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zweitag/GeoFaker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GeoFaker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/geo_faker/blob/master/CODE_OF_CONDUCT.md).

