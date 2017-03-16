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


    # Find an Element definition by name (inherited from Vidalia::Artifact)
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: specifies the name of the Element to search for
    #
    # *Example*
    #
    #   blog_post = Vidalia::Element.find_definition("Blog Post")
    #
    def self.find_definition(name)
      super
    end

  
    # Set the parent Object of this Element
    #
    # *Options*
    #
    # This method takes one parameter
    # +object+:: specifies a Vidalia::Object to be set as the parent
    #
    # *Example*
    #
    #   # Note that both the "Blog API" and "Blog Post" Elements must be predefined
    #   blog_api = Vidalia::Element.new("Blog API")
    #   blog_post = Vidalia::Element.new("Blog Post")
    #   blog_post.set_parent(blog_api)
    # 
    def set_parent(object)
      Vidalia::checkvar(object,Vidalia::Object,self.class.ancestors,"parent object")
      super
    end
  
    
  end

end
