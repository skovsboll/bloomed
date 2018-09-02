# Bloomed

Troy Hunt's brilliant haveibeenpwned.com let's you download SHA1s of 517,238,891 real world passwords previously exposed in data breaches. This list is comprehensive but huge in size: 11GB compressed.
Using a bloom filter we can reduce the size down to files measured in MBs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bloomed'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bloomed

## Usage

There are two ways to vary the size and the accuracy of the bloom filter.

To keep this repo small you'll only find a sma



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bloomed. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bloomed project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bloomed/blob/master/CODE_OF_CONDUCT.md).
