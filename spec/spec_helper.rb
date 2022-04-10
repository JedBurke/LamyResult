# frozen_string_literal: true

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end


  # Since the class is modified, LamyResult needs to be clean with every
  # example. To do that, we'll require and unload the const on each run.
  config.around(:each) do |example|
    unless Object.const_defined? :LamyResult
      require 'lamy_result'
    end

    example.run

    if Object.const_defined?('LamyResult')
      LamyResult.send(:remove_const, 'Lamy')
      Object.send(:remove_const, 'LamyResult')

      # Remove all of Lamy from the loaded features. Let's say goodbye so
      # that we can say hello again! See `require` at the top of the block.
      $LOADED_FEATURES.reject! do |path|
        path =~ /\/lamy\//i
      end

    end

  end

end
