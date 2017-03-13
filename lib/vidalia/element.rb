module Vidalia

  class Element < Artifact
 
    attr_reader :name, :parent

    # Define an Element (inherited from Vidalia::Artifact)
    #
    # This routine saves the specified Element parameters to the master list 
    # of Elements.  When a user instantiates a Vidalia::Element, it will 
    # initialize the Element with this data and run the specified block of code.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the Element
    # +object+:: specifies the Object that the Element is associated with
    # +block+:: specifies the block of code to be run when the Element is initialized
    #
    # *Example*
    #
    #   Vidalia::Element.define(
    #     :name => "Subject",
    #     :object => "Blog Post",
    #     :interface => "Blog API"
    #   ) {
    #     @data = {
    #       "subject" => nil,
    #       "body" => nil,
    #       "author" => nil,
    #       "date_posted" => nil
    #     }
    #   }
    #
    def self.define(opts = {}, &block)
      opts[:type] = Vidalia::Element
      super
    end


    # Get Vidalia master Element data
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: a string specifying the name of the Element
    #
    # *Example*
    #
    #   Vidalia::Element.get_definition_data("Blog Post")
    #
    def self.get_definition_data(name,parent)
      super
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
    #   blog_post = Vidalia::Element.new("Blog Post")
    #
    def initialize(opts = {})
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
