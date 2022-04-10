# frozen_string_literal: true

require_relative 'lib/lamy_result/version'

Gem::Specification.new do |spec|
  spec.name          = 'lamy_result'
  spec.version       = LamyResult::VERSION
  spec.authors       = ['Jed Burke']
  spec.email         = ['opensource@evrnetwork.co.za']

  spec.summary       = 'Wrap results with a status and a value.'
  spec.description   = <<~EOF
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
  EOF

  spec.homepage      = 'https://evrnetwork.co.za'
  spec.license       = 'Apache-2.0'
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/JedBurke/LamyResult'
  spec.metadata['changelog_uri'] = 'https://github.com/JedBurke/LamyResult/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
