# Lamy Result

Lamy Result is a simple utility used to wrap method results with a status and a value.

The project is inspired by Elixir and Erlang's tagged tuple and Rust's Result/Option. Despite inspiration from other languages, Lamy Result aims to be idiomatic Ruby and runtime dependency-free.

Rather than change the way you're doing things. Returning a single result is great for most cases. You'll know if and when you need something more.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lamy_result'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install lamy_result

[LamyResult](https://rubygems.org/gems/lamy_result) on RubyGems.org

## Usage

A few pre-designed status labels are included: `succeeded` `ok` `failed` `error` `true` `false`

Providing a short-hand way to create a result, each statuc corresponds to a static method (or class method) on the Lamy class.

For example, `Lamy.failed('You did not think this through.')` will return a Lamy instance with the status set to `:failed` and the value to `You did not think this through.`

Here are some basic examples.

```ruby
require 'lamy_result'

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

# When either of the input statuses match the instance's status, the
# instance value will be yielded to the block.
result.any_then(:ok, :success) do |value|
  value.upcase
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

## Motivation

The idea came from a function which would check if a file exists with either dashes or underscores. If I was looking for `./ecchi/ecchi-pic-7.jpg`, it should also check for `./ecchi/ecchi_pic_7.jpg`. Without going on a tangent, the function is meant to reconcile file name inconsistencies.

The return value could  be the file name if it exists and false if does not. Returning a hash with `status` and `value` was more appealing. And that's where we are now.

## Name?

Named after the hololive VTuber Yukihana Lamy. I was watching her content while designing the class. Thought that maybe naming it in honor of her would give me the motivation to deliver a documented and tested production-ready gem. It's now more complicated than initially intended. So maybe it wasn't a good idea.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JedBurke/LamyResult.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).
