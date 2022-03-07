# Lamy Result

Lamy Result is a simple, dependency-free, idiomatic-Ruby utility used to wrap method results with a status and a value. It's inspired by Elixir and Erlang's tagged tuple and Rust's Result/Option.

Lamy Result is a simple utility (implemented in an unnecessarily complex manner) which wraps method return values with a status. Elixir and Erlang's tagged tuple is the main inspiration, so are Rust's Rusult/Option functions. Despite being influenced by other languages, LR aims to be as idiomatic-Ruby as possible. It's also free of runtime dependencies.

```ruby
include LamyResult

result = Lamy.ok('Lamy is awesome')

if result.ok?
  do_something_cool result.value
end

# or

# Will only evaluate if the status is :ok
result.ok_then do |v|
  do_something_cool v
end

result.to_a
# Output: [:ok, 'Lamy is awesome']

result.to_h
# Output: { status: :ok, value: 'Lamy is awesome' }
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lamy-result'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install lamy-result

## Usage

A few pre-designed status labels are included: `success` `ok` `failed` `error` `true` `false`

As a short-hand way to create a result, each one corresponds to a static method (or class method) on the Lamy class.

For example, Lamy.failed('You did not think this through.') will instantize a Lamy instance with the status set to `:failed` and the value to `You did not think this through.`


## Motivation


## Name?

Named after the hololive VTuber Yukihana Lamy. I was watching her content while designing the class. Then I thought that if I named it after her I would do a solid job documenting and testing the code.

Maybe it wasn't a good idea. It's now far more complicated than initially intended.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JedBurke/lamy-result.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).
