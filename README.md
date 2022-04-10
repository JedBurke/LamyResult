# Lamy Result

Lamy Result is a simple utility used to wrap method results with a status and a value.

The project is inspired by Elixir and Erlang's tagged tuple and Rust's Result/Option. Despite inspiration from other languages, Lamy Result aims to be idiomatic Ruby and runtime dependency-free.

Rather than change the way you're doing things. Returning a single result is great for most cases. You'll know if and when you need something more.

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


# Aliases allow for natural expression.

def do_another_cool_thing
  # Report success
  Lamy.success('It worked')
end

another_result = do_another_cool_thing

# As in "Was the operation successful?"
another_result.successful?

# As in "Has the operation succeeded?"
another_result.succeeded?
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lamy_result'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install lamy_result

## Usage

A few pre-designed status labels are included: `success` `ok` `failed` `error` `true` `false`

As a short-hand way to create a result, each one corresponds to a static method (or class method) on the Lamy class.

For example, Lamy.failed('You did not think this through.') will instantize a Lamy instance with the status set to `:failed` and the value to `You did not think this through.`


## Motivation

The idea came from a function which would check if a file exists with either dashes or underscores. If I was looking for `./ecchi/ecchi-pic-7.jpg`, it should also check for `./ecchi/ecchi_pic_7.jpg`. Without going on a tangent, the function is meant to reconcile file name inconsistencies.

The return value could  be the file name if it exists and false if does not. Returning a hash with `status` and `value` was more appealing. And that's where we are now.

## Name?

Named after the hololive VTuber Yukihana Lamy. I was watching her content while designing the class. Thought that maybe naming it in honor of her would give me the motivation to deliver a documented and tested production-ready gem. It's now more complicated than initially intended. So maybe it wasn't a good idea.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JedBurke/LamyResult.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).
