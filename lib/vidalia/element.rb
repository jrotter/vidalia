module Vidalia
  # Represents a single data element accessed through an entity, provides either
  # default or user-specified methods to get and set the value of the element
  class Element
    private

    # Set the generic retrieve directive
    def add_generic_retrieve
      @retrieve_function = @get_function
    end

    # Set the generic verify directive
    # TODO: Consider raising a custom error here
    def add_generic_verify
      @verify_function = proc do |value|
        found_value = retrieve value
        if value == found_value
          Vidalia.log "Verified #{@human_name} to be \"#{value}\""
        else
          raise "Expected #{@human_name} to be \"#{value}\", but found " \
                "\"#{found_value}\" instead"
        end
        true
      end
    end

    # Set the generic update directive
    def add_generic_update
      @update_function = proc do |value|
        new_value = value
        found_value = retrieve
        if new_value == found_value
          capital_text = @human_name
          capital_text[0] = capital_text[0].capitalize
          Vidalia.log "#{capital_text} is already set to \"#{new_value}\""
        else
          Vidalia.log "Entering #{@human_name}: \"#{new_value}\" (was " \
                      "\"#{found_value}\")"
          set new_value
        end
      end
    end

    # Set the generic confirm directive
    def add_generic_confirm
      @confirm_function = proc do |value|
        retval = false
        found_value = retrieve value
        retval = true if value == found_value
        retval
      end
    end

    # Add retrieve, verify, confirm, and update methods if needed
    def generic_hooks
      if @get_function
        add_generic_retrieve unless @retrieve_function
        add_generic_verify unless @verify_function
        add_generic_confirm unless @confirm_function
        # Update needs a get and set
        add_generic_update if @set_function && !@update_function
      end
    end

    public

    # Create an Element given its parent entity and a definition block
    #
    # @param [String or Symbol] human_name a human-readable name for the element
    #   to be used in logging
    # @param [Vidalia::Entity] parent_entity the entity the element belongs to,
    #   used to give the element access to entity's instance variables
    # @param [Proc] definition_block the DSL code block used to define the
    #   element
    #
    # @todo: make this consistent in error handling/param checking with
    #   Vidalia::Entity.new
    def initialize(human_name, parent_entity: nil, definition_block: nil)
      @human_name = human_name.to_s
      @get_function ||= nil
      @set_function ||= nil
      @retrieve_function ||= nil
      @verify_function ||= nil
      @update_function ||= nil
      @confirm_function ||= nil
      instance_exec(parent_entity, &definition_block)
    end

    # Used as either a DSL method to define a get method for the element or to
    # call a get method that is already defined
    #
    # @param [Object] param a parameter to pass to the get method, generally
    #   not useful for get methods
    #
    # @return [Object] the value returned by the element's get method, if a
    #   pre-defined get method is being called
    def get(param = nil, &block)
      if block
        @get_function = block
        generic_hooks
      else
        @get_function.call param
      end
    end

    # Used as either a DSL method to define a set method for the element or to
    # call a set method that is already defined
    #
    # @todo assert param exists when not being used for DSL
    #
    # @param [Object] param a parameter to pass to the set method, generally
    #   used as the value to set the element to
    def set(param = nil, &block)
      if block
        @set_function = block
        generic_hooks
      else
        @set_function.call param
      end
    end

    # Call the retrieve method
    #
    # @param [Object] param a parameter to pass to the retrieve method,
    #   generally not useful for retrieve methods
    #
    # @return [Object] the retrieved element value
    def retrieve(param = nil)
      @retrieve_function.call param
    end

    # Verify the element's actual value matches an expected value
    #
    # @param [Object] exp the expected value to check the element's value
    #   against
    #
    # @todo identify or define a type of error appropriate to raise when
    #   verification fails
    # @raise [RuntimeError] the error raised when verification fails
    def verify(exp)
      @verify_function.call exp
    end

    # Check if the element's actual value matches an expected value
    #
    # @param [Object] exp the expected value to check the element's value
    #   against
    #
    # @return [Boolean] true if the expected value matches the element's value,
    #   false if not
    def confirm(exp)
      @confirm_function.call exp
    end

    # Call the update method on the element
    #
    # @param [Object] param the parameter to pass into the update method,
    #   generally used to overwrite the value of the element with +param+
    def update(param)
      @update_function.call param
    end
  end
end
