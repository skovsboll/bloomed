# Bloomed

Troy Hunt's brilliant haveibeenpwned.com let's you download SHA1s of 517,238,891 real world passwords previously exposed in data breaches. This list is comprehensive but huge in size: 11GB compressed.
Using a bloom filter we can reduce the size down to files measured in MBs.

You can even keep a the bloom filter in memory in your web app or api. This is great if you're afraid to send the passwords that your users enter, to an external service for lookup.

This gem will let you control the trade off between memory size and precision. False positives will occur (that's the nature of bloom filters), but you control the frequency and how many of the pwned passwords you want in your filter, starting from the most pwned at the top.

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

### Quick start

```ruby
require 'bloomed'
pw = Bloomed::PW.new
pw.pwned? "password123"
=> true
```

### Using lower precision / lower memory consumption

There are two parameters that can be varied: `top` and `false_positive_probability`.


```ruby
require 'bloomed'
pw = Bloomed::PW.new(top: 100000, false_positive_probability: 0.01) # 136 kb memory
pw.pwned? "password123"
=> true
```

### Using higher precision / higher memory consumption

To keep the gem size small, it only ships with dumps up to 253 kb in size.

To generate all combinations of `top` and `false_positive_probability` bloom filters for pwned passwords, run:

`rake seed\[all\]`

This will download the source 7zip file with pwned passwords, unpack it to the current dir, write the generated bloom filters in the lib/dump dir relative to the installation path of the gem.

Note: You'll need to `brew install curl p7zip` on macos and `apt-get install curl p7zip` on linux.

Sometimes you will want to have more precise control of the placement of the cache files. To seed all variants in the current dir, run:

```
rake seed_here\[all\]
```

But be aware that it will take a long time!

Once you have the massive 22GB text files available, you can generate binary cache files using the exact precision you want.

```ruby
require 'bloomed'
pw = Bloomed::PW.new(top:1E9, false_positive_probability: 0.0001)
```

Warning! This seeds all the passwords and will take a loooong time the first time. Even with a binary cache file in place loading it will take massive time and memory.

For deployment scenarios where you don't want the server to `rake seed`, you can override the directory used for caching by giving a `cache_dir` argument to the constructor:

```ruby
require 'bloomed'
pw = Bloomed::PW.new(top:1E8, false_positive_probability: 0.0001, cache_dir: '/var/lib/bloomed'
)
```

### Size of the in memory bloom filter

The filter can vary much in size. Use `Bloomed:PW#memory_size_bytes` to get the exact size.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skovsboll/bloomed. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bloomed project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bloomed/blob/master/CODE_OF_CONDUCT.md).
