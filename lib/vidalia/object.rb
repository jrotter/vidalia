module Vidalia

  class Object < Artifact
 
    attr_reader :name, :parent

    # Define an Object (inherited from Vidalia::Artifact)
    #
    # This routine saves the specified Object parameters to the master list 
    # of Objects.  When a user instantiates a Vidalia::Object, it will 
    # initialize the Object with this data and run the specified block of code.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the Object
    # +interface+:: specifies the Interface that the Object is associated with
    # +block+:: specifies the block of code to be run when the Object is initialized
    #
    # *Example*
    #
    #   Vidalia::Object.define(:name => "Blog Post",:interface => "Blog API") {
    #     @data = {
    #       "subject" => nil,
    #       "body" => nil,
    #       "author" => nil,
    #       "date_posted" => nil
    #     }
    #   }
    #
    def self.define(opts = {}, &block)
      super
    end


    # Get Vidalia master Object data
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: a string specifying the name of the Object
    #
    # *Example*
    #
    #   Vidalia::Object.get_definition_data("Blog Post")
    #
    def self.get_definition_data(name)
      super
    end

  
    # Create an Object (inherited from Vidalia::Artifact)
    #
    # Initializes a Vidalia::Object using the data set in 
    # Vidalia::Object.define.  If such data does not exist, this routine will 
    # error out.  This ensures that all Objects have been predefined.
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: specifies the name of the Object
    #
    # *Example*
    #
    #   blog_post = Vidalia::Interface.new("Blog Post")
    #
    def initialize(name)
      super
    end


    # Find an Object definition by name (inherited from Vidalia::Artifact)
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: specifies the name of the Object to search for
    #
    # *Example*
    #
    #   blog_post = Vidalia::Object.find_definition("Blog Post")
    #
    def self.find_definition(name)
      super
    end

  
    # Add a child Element to this Object
    #
    # *Options*
    #
    # This method takes one parameter:
    # +element+:: specifies a Vidalia::Element to be added as a child
    #
    # *Example*
    #
    #   blog_post = Vidalia::Object.new("Blog Post")
    #   subject = Vidalia::Element.new("Subject")
    #   blog_post.add_element(subject)
    #
    def add_element(element)
      Vidalia::checkvar(element,Vidalia::Element,self.class.ancestors,"child element")
      add_child(element)
    end


    # Get a child Element from this Object
    #
    # *Options*
    #
    # This method takes one parameter:
    # +name+:: specifies the name of a Vidalia::Element that is a child of this Object
    #
    # *Example*
    #
    #   blog_post = Vidalia::Object.new("Blog Post")
    #   subject = Vidalia::Element.new("Subject")
    #   blog_post.add_element(subject)
    #   my_child = blog_post.element("Subject")
    #
    def element(name)
      Vidalia::checkvar(name,String,self.class.ancestors,"element name")
      get_child(name)
    end


    # Set the parent Interface of this Object
    #
    # *Options*
    #
    # This method takes one parameter
    # +interface+:: specifies a Vidalia::Interface to be set as the parent
    #
    # *Example*
    #
    #   # Note that both the "Blog API" and "Blog Post" Objects must be predefined
    #   blog_api = Vidalia::Object.new("Blog API")
    #   blog_post = Vidalia::Object.new("Blog Post")
    #   blog_post.set_parent(blog_api)
    # 
    def set_parent(interface)
      Vidalia::checkvar(interface,Vidalia::Interface,self.class.ancestors,"parent interface")
      super
    end
  
    
  end

end
