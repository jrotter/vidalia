module Vidalia

  class Element < Artifact
 
    attr_reader :name, :parent, :set_function, :get_function

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
      end
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
      @get_function.call(inparams)
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
      @set_function.call(inparams)
    end


  end

end
