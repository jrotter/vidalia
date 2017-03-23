module Vidalia

  class Element < Artifact
 
    attr_reader :name, :parent, :set_function, :get_function, :retrieve_function, :verify_function, :confirm_function, :update_function

    # Define an Element
    #
    # This routine takes a Vidalia::ObjectDefinition and adds an Element
    # definition to the associated Object.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the Element
    # +parent+:: specifies the Object that the Element is associated with
    #
    # +block+:: specifies the block of code to be run when the Element is initialized
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def self.define(opts = {}, &block)
      Vidalia::ElementDefinition.new(opts,&block)
    end


    # Create an Element (inherited from Vidalia::Artifact)
    #
    # Initializes a Vidalia::Element using the data set in 
    # Vidalia::Element.define.  If such data does not exist, this routine will 
    # error out.  This ensures that all Elements have been predefined.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the Interface
    # +parent+:: specifies the Vidalia::Identifier of the parent object
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def initialize(opts = {})
      o = {
        :name => nil,
        :parent => nil,
        :definition => nil,
      }.merge(opts)

      @type = Vidalia::Element
      super
      if o[:definition]
        my_def = o[:definition]
        Vidalia::checkvar(my_def,Vidalia::Element,self.class.ancestors,"definition")
        @get_function = my_def.get_function
        @set_function = my_def.set_function
        @retrieve_function = my_def.retrieve_function
        @verify_function = my_def.verify_function
        @confirm_function = my_def.confirm_function
        @update_function = my_def.update_function
        if @get_function
          add_generic_retrieve() unless @retrieve_function
          add_generic_verify() unless @verify_function
          add_generic_confirm() unless @confirm_function
          if @set_function
            add_generic_update() unless @update_function
          end
        end
      end
    end


    # Set the generic retrieve directive for this Element
    #
    # *Options*
    #
    # Takes no parameters.
    #
    # *Example*
    #
    #   $$$ Example Needed $$$
    #
    def add_generic_retrieve()
      @retrieve_function = @get_function
    end


    # Set the generic verify directive for this Element
    #
    # *Options*
    #
    # Takes no parameters.
    #
    # *Example*
    #
    #   $$$ Example Needed $$$
    #
    def add_generic_verify()
      add_verify { |value|
        found_value = retrieve(value)
        if value == found_value
          Vidalia.log("Verified #{@name} to be \"#{value}\"")
        else
          raise "Expected #{@name} to be \"#{value}\", but found \"#{found_value}\" instead"
        end
        true
      }
    end


    # Set the generic confirm directive for this Element
    #
    # *Options*
    #
    # Takes no parameters.
    #
    # *Example*
    #
    #   $$$ Example Needed $$$
    #
    def add_generic_confirm()
      add_confirm { |value|
        retval = false
        found_value = retrieve(value)
        if value == found_value
          retval = true
        end
        retval
      }
    end


    # Set the generic update directive for this Element
    #
    # *Options*
    #
    # Takes no parameters.
    #
    # *Example*
    #
    #   $$$ Example Needed $$$
    #
    def add_generic_update()
      add_update { |value|
        new_value = value
        found_value = retrieve()
        if new_value == found_value
          capital_text = @name
          capital_text[0] = capital_text[0].capitalize
          Vidalia.log("#{capital_text} is already set to \"#{new_value}\"")
        else
          Vidalia.log("Entering #{@name}: \"#{new_value}\" (was \"#{found_value}\")")
          set(new_value)
        end
      }
    end


    # Copy an Interface from another Interface (inherited from Vidalia::Artifact)
    #
    # *Options*
    #
    # Takes one parameter:
    # +source+:: specifies the name of the Interface to copy from
    #
    # *Example*
    #
    #   $$$ Example Needed $$$
    #
    def self.copy_from(source)
      super
    end

  
    # Add a "get" function
    #
    # This function will be called to obtain the data element value from the
    # Object.  A call to "get" really makes the most sense AFTER obtaining
    # data from the database/API.
    #
    # *Options*
    #
    # Takes a block to be executed when "get" for this Element is invoked.
    # The input block should take a hash as a parameter.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def add_get(&block)
      @get_function = block
    end


    # Call the "get" function
    #
    # Call the pre-defined "get" function for this element.
    #
    # *Options*
    #
    # Takes a hash as input, with data as expected by the pre-defined "get" 
    # block.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def get(inparams = {})
      block = @get_function
      instance_exec(inparams,&block)
    end


    # Add a "set" function
    #
    # This function will be called to set the element's value in the Object.
    # Object.  A call to "set" really makes the most sense BEFORE making an
    # alteration to the Object data via database/API call.
    #
    # *Options*
    #
    # Takes a block to be executed when "set" for this Element is invoked.
    # The input block should take a hash as a parameter.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def add_set(&block)
      @set_function = block
    end


    # Call the "set" function
    #
    # Call the pre-defined "set" function for this element.
    #
    # *Options*
    #
    # Takes a hash as input, with data as expected by the pre-defined "set" 
    # block.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def set(inparams = {})
      block = @set_function
      instance_exec(inparams,&block)
    end


    # Add a "retrieve" function
    #
    # This function will be called to obtain the data element value from the
    # Object.  A call to "retrieve" really makes the most sense AFTER obtaining
    # data from the database/API.
    #
    # *Options*
    #
    # Takes a block to be executed when "retrieve" for this Element is invoked.
    # The input block should take a hash as a parameter.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def add_retrieve(&block)
      @retrieve_function = block
    end


    # Call the "retrieve" function
    #
    # Call the pre-defined "retrieve" function for this element.
    #
    # *Options*
    #
    # Takes a hash as input, with data as expected by the pre-defined "retrieve" 
    # block.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def retrieve(inparams = {})
      block = @retrieve_function
      instance_exec(inparams,&block)
    end


    # Add a "verify" function
    #
    # This function will be called to obtain the data element value from the
    # Object.  A call to "verify" really makes the most sense AFTER obtaining
    # data from the database/API.
    #
    # *Options*
    #
    # Takes a block to be executed when "verify" for this Element is invoked.
    # The input block should take a hash as a parameter.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def add_verify(&block)
      @verify_function = block
    end


    # Call the "verify" function
    #
    # Call the pre-defined "verify" function for this element.
    #
    # *Options*
    #
    # Takes a hash as input, with data as expected by the pre-defined "verify" 
    # block.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def verify(inparams = {})
      block = @verify_function
      instance_exec(inparams,&block)
    end


    # Add a "confirm" function
    #
    # This function will be called to obtain the data element value from the
    # Object.  A call to "confirm" really makes the most sense AFTER obtaining
    # data from the database/API.
    #
    # *Options*
    #
    # Takes a block to be executed when "confirm" for this Element is invoked.
    # The input block should take a hash as a parameter.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def add_confirm(&block)
      @confirm_function = block
    end


    # Call the "confirm" function
    #
    # Call the pre-defined "confirm" function for this element.
    #
    # *Options*
    #
    # Takes a hash as input, with data as expected by the pre-defined "confirm" 
    # block.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def confirm(inparams = {})
      block = @confirm_function
      instance_exec(inparams,&block)
    end


    # Add a "update" function
    #
    # This function will be called to obtain the data element value from the
    # Object.  A call to "update" really makes the most sense AFTER obtaining
    # data from the database/API.
    #
    # *Options*
    #
    # Takes a block to be executed when "update" for this Element is invoked.
    # The input block should take a hash as a parameter.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def add_update(&block)
      @update_function = block
    end


    # Call the "update" function
    #
    # Call the pre-defined "update" function for this element.
    #
    # *Options*
    #
    # Takes a hash as input, with data as expected by the pre-defined "update" 
    # block.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def update(inparams = {})
      block = @update_function
      instance_exec(inparams,&block)
    end


  end

end
