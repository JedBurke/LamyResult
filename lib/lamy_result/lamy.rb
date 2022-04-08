# frozen_string_literal: true

module LamyResult

  # Creates and checks result instances.
  #
  # A quick reference for class and instance methods.
  #   Lamy.ok is a class method to be called on the `Lamy` class.
  #
  #   Lamy#ok? is an instance method called on a Lamy instance, which is
  #   returned by Lamy.ok.
  #     result = Lamy.ok(Excon.get('https://example.com'))
  #     result.ok? => true
  #
  #   See .define_status_tags for the method defined at runtime.
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

    # # Handle method missing errors to dynamically create them when needed.
    # # Also call the newly created method.
    # def method_missing(missing_method_symbol, **args, &block)
    #   case missing_method_symbol.to_s

    #   # Define the required status check method like `#ok?`
    #   when /^(?<result_status>.+?)\?$/

    #     self
    #       .class
    #       .define_method(missing_method_symbol) do
    #         # Get the status that we need to check. It should have
    #         # been captured.
    #         status_is?(Regexp.last_match[:result_status])
    #       end

    #     send(missing_method_symbol)

    #   # Dynamically define the conditional method like `#ok_then`
    #   when /^(?<status>.+?)_then$/
    #     self
    #       .class
    #       .send(:define_method, missing_method_symbol) do |&method_block|
    #         assert_status_then(
    #           status_to_check: Regexp.last_match[:status],
    #           &method_block
    #         )
    #       end

    #     send(missing_method_symbol, &block)

    #   # There isn't a match, so allow the error to crash the application!
    #   else
    #     super
    #   end
    # end

    # Adds one or more new status tags to be used by the
    def self.define_status_tags(*status_tags)
      # Use Array() over [] to create an array if status_tags is not an array,
      # but not create an array within an array.
      Array(
        status_tags
      ).each do |status|
        new_status, *new_status_aliases = Array(status)

        # Defines the short-hand class method like .ok(input)
        self.define_status_method(new_status, *new_status_aliases)

        # Define status check instance methods like #ok?
        self.define_status_check_method(new_status, *new_status_aliases)

        # Define conditional instance methods like #ok_then
        self.define_conditional_then_method(new_status, *new_status_aliases)
      end
    end

    def self.format_status_check_method(status)
      "#{status.to_s}?".to_sym
    end

    def self.format_conditional_method(status)
      "#{status.to_s}_then".to_sym
    end

    def self.define_status_method(status, *aliases)
      self
      .class
      .send(:define_method, status) do |value|
        Lamy.new(status: status, value: value)
      end

      # Define aliases for the new status if we got any.
      define_class_aliases_for(status, *aliases)
    end

    # Defines an instance method to check the status label. E.g. #ok?
    def self.define_status_check_method(status, *aliases)
      method_symbol = format_status_check_method(status)
      status_check_aliases = aliases.map do |s|
        format_status_check_method(s)
      end

      define_method(method_symbol) do
        # Get the status that we need to check. It should have
        # been captured.
        status_is?(status.to_sym)
      end

      assert_new_instance_method! method_symbol

      self.define_instance_aliases_for(method_symbol, *status_check_aliases)
    end

    def self.define_conditional_then_method(status, *aliases)
      method_symbol = format_conditional_method(status)
      status_conditional_aliases = aliases.map do |s|
        format_conditional_method(s)
      end

      define_method(method_symbol) do |&method_block|
        assert_status_then(status_to_check: status, &method_block)
      end

      assert_new_instance_method! method_symbol

      define_instance_aliases_for(
        method_symbol,
        *status_conditional_aliases
      )
    end

    # Checks if the method is an instance method, otherwise raises a
    # StandardError.
    def self.assert_new_instance_method!(method_symbol)
      unless self.instance_methods.include?(method_symbol)
        raise StandardError.new "##{method_symbol} is not an instance method."
      end

      true
    end

    # Defines a class or instance alias for the supplied method with each of
    # the supplied array items.
    def self.define_aliases_for(
      method_symbol,
      instance_alias,
      *method_aliases
    )
      method_aliases.each do |method_alias|
        if instance_alias
          alias_method(method_alias, method_symbol)
        else
          self.class.alias_method(method_alias, method_symbol)
        end
      end

      true
    end

    def self.define_class_aliases_for(method_symbol, *method_aliases)
      define_aliases_for(method_symbol, false, *method_aliases)
    end

    # Defines an instance alias for the supplied method with each of
    # the supplied array items.
    def self.define_instance_aliases_for(method_symbol, *method_aliases)
      define_aliases_for(
        method_symbol,
        true,
        *method_aliases
      )
    end

    # Override the equality operators and set them as aliases for
    # the #status_is? method.
    alias == status_is?
    alias eql? status_is?

    class << self
      # The singular form may be more comfortable for users wanting to define
      # a single tag.
      alias define_status_tag define_status_tags

      # `add_status_tags` might be more comfortable or easier to remember than
      # `define_status_tags`
      alias add_status_tags define_status_tags
      alias add_status_tag define_status_tags
    end

    # Add the basic tags to the class.
    Lamy.define_status_tags(
      [:succeeded, :success, :successful],
      [:failed, :fail, :error],
      :ok,
      :true,
      :false
    )
  end
end

# TODO: Allow tag aliases.
# Lamy.define_status_tags([:success, :succeeded, :successful])
# result = Lamy.success('Hello')
# result.successful? => true

# TODO: Drop method_missing and define all the methods when the status
# is added.
