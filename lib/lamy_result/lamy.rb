# frozen_string_literal: true

module LamyResult

  # Creates and checks result instances.
  class Lamy
    def initialize(status:, value: nil)
      @status = status
                .to_s
                .downcase
                .to_sym

      @value = value
    end

    # The raw attributes may be accessed from outside the class, but
    # shouldn't be changed once set.
    attr_reader :status,
                :value

    # Compares the current instance's status to the input value. This is a
    # lov-level method meant to be used by the #ok? and #success? methods.
    def status_is?(value)
      @status == value.to_sym
    end

    # Calls #status_is? on the `status_to_check` and if true, yields the value.
    # Otherwise, returns the instance. This is a low-level method meant to be
    # used by #ok_then and #success_then methods.
    def assert_status_then(status_to_check:)
      if status_is?(status_to_check)
        return yield @value if block_given?

        return @value
      end

      self
    end

    # Returns the status attribute as a symbol or a TrueClass/FalseClass. This
    # is a low-level method meant to be used by #to_a and #to_h.
    def export_status
      # If the status is a boolean, return the status as a boolean.
      # Otherwise, return it as a symbol, which it should already be.
      if true? || false?
        @status.to_s.to_sym == true.to_s.to_sym
      else
        @status.to_s.to_sym
      end
    end

    # Returns an array of the instance. The status instance attribute is
    # first and the value attribute is second. The status will be returned
    # as a symbol unless it is true or false. At which point, it will
    # be converted.
    def to_a
      [
        export_status,
        @value
      ]
    end

    # Returns a hash of the instance with @status under the `status` key
    # and @value under the `value` key. The status will be returned as a
    # symbol unless it is true or false. At which point, it will be converted.
    def to_h
      {
        status: export_status,
        value: @value
      }
    end

    # Handle method missing errors to dynamically create them when needed.
    # Also call the newly created method.
    def method_missing(missing_method_symbol, **args, &block)
      case missing_method_symbol.to_s

      # Define the required status check method like `#ok?`
      when /^(?<result_status>.+?)\?$/

        self
          .class
          .define_method(missing_method_symbol) do
            # Get the status that we need to check. It should have
            # been captured.
            status_is?(Regexp.last_match[:result_status])
          end

        send(missing_method_symbol)

      # Dynamically define the conditional method like `#ok_then`
      when /^(?<status>.+?)_then$/
        self
          .class
          .send(:define_method, missing_method_symbol) do |&method_block|
            assert_status_then(
              status_to_check: Regexp.last_match[:status],
              &method_block
            )
          end

        send(missing_method_symbol, &block)

      # There isn't a match, so allow the error to crash the application!
      else
        super
      end
    end

    # Adds one or more new status tags to be used by the
    def self.define_status_tags(*status_tags)
      Array(status_tags)
        .each do |status|
          self
            .class
            .send(:define_method, status.to_sym) do |value|
              Lamy.new(status: status, value: value)
            end
        end
    end

    # Override the equality operators and set them as aliases for
    # the #status_is? method.
    alias == status_is?
    alias eql? status_is?

    class << self
      alias add_status_tags define_status_tags
      alias add_status_tag define_status_tags
      alias define_status_tag define_status_tags
    end

    # Add the basic tags to the class.
    Lamy.define_status_tags(
      :success,
      :ok,
      :failed,
      :error,
      :true,
      :false
    )
  end
end
