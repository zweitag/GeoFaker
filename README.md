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

### Around
Pick a random point around the center of the given location.
The distance of these points to the center follows a normal distribution with the given radius *r* as standard deviation σ.
To avoid extreme outliers, we do not allow any points with a distance greater than *3r*.
This means roughly 68% of points will be inside of the given radius and roughly 95% of points will be within a *2r*.
```ruby
require 'geo_faker'

point = GeoFaker.around('Alter Fischmarkt 12, Münster', radius_in_km: 1)
=> #<Point:0x000055b93554c4c0 @lat=51.96598262572216, @lon=7.630330692658974>
point.lat
=> 51.96598262572216
point.lon
=> 7.630330692658974
```

### Within
Pick a random, uniformly distributed point within the boundary polygon reported by the Nominatim API.
Currently this only works for places with exactly one boundary polygon. This means, it does not work for countries with exclaves or islands for now.
```ruby
GeoFaker.within('Allwetterzoo')
=> #<Point:0x000055b9354e8c90 @lat=51.94596285994424, @lon=7.591793493383972>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### CI

We used Travis as our CI build tool. With the migration to Github we deleted the file. On this page it is described what Travis does and how it is specified (https://docs.travis-ci.com/user/languages/ruby/). If the project gets under active development you can use this to rebuild the CI pipeline.

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
