module Vidalia

  class Element < Artifact
 
    attr_reader :name, :parent

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

  
  end

end
