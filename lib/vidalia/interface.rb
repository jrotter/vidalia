module Vidalia

  class Interface < Artifact

    attr_reader :name, :parent

    # Define an Interface (inherited from Vidalia::Artifact)
    #
    # This routine saves the specified Interface parameters to the master list 
    # of Interfaces.  When a user instantiates a Vidalia::Interface, it will 
    # initialize the object with this data and run the specified block of code.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the interface
    # +block+:: specifies the block of code to be run when the interface object is initialized
    #
    # *Example*
    #
    #   Vidalia::Interface.define(:name => "Blog API") {
    #     @db_password = ENV['BLOG_DB_PASSWORD']
    #     @db_userid = ENV['BLOG_DB_PASSWORD']
    #     @db_ip = ENV['BLOG_DB_IP']
    #     @db_port = ENV['BLOG_DB_PORT']
    #   }
    #
    def self.define(opts = {}, &block)
      opts[:type] = Vidalia::Interface
      super
    end


    # Get Vidalia master Interface data (inherited from Vidalia::Artifact)
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: a string specifying the name of the Interface
    #
    # *Example*
    #
    #   Vidalia::Interface.get_definition_data("Blog API")
    #
    def self.get_definition_data(name,parent)
      super
    end


    # Create an Interface (inherited from Vidalia::Artifact)
    #
    # Initializes a Vidalia::Interface using the data set in Vidalia::Interface.define.  If such data
    # does not exist, this routine will error out.  This ensures that all Interfaces have been
    # predefined.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the Interface
    # +parent+:: specifies the Vidalia::Identifier of the parent object
    #
    # *Example*
    #
    #   blog_api = Vidalia::Interface.new("Blog API")
    #
    def initialize(opts = {})
      @type = Vidalia::Interface
      super
    end


    # Find an Interface definition by name (inherited from Vidalia::Artifact)
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: specifies the name of the Interface to search for
    #
    # *Example*
    #
    #   blog_api = Vidalia::Interface.find_definition("Blog API")
    #
    def self.find_definition(name)
      super
    end

  
    # Add a child Object to this Interface (inherited from Vidalia::Artifact)
    #
    # *Options*
    #
    # This method takes one parameter:
    # +object+:: specifies a Vidalia::Object to be added as a child
    #
    # *Example*
    #
    #   # Note that both the "Blog API" and "Blog Post" Interfaces must be predefined
    #   blog_api = Vidalia::Interface.new("Blog API")
    #   blog_post = Vidalia::Object.new("Blog Post")
    #   blog_api.add_object(blog_post)
    #
    def add_object(object)
      Vidalia::checkvar(object,Vidalia::Object,self.class.ancestors,"child object")
      add_child(object)
    end


    # Retrieve a child Object of this Interface by name
    #
    # *Options*
    #
    # This method takes one parameter:
    # +child_name+:: specifies the name of the child Object
    #
    # *Example*
    #
    #   # Note that both the "Blog API" and "Blog Post" Interfaces must be predefined
    #   blog_api = Vidalia::Interface.new("Blog API")
    #   blog_post = Vidalia::Object.new("Blog Post")
    #   blog_api.add_object(blog_post)
    #   my_child = blog_api.object("Blog Post")
    #
    def object(child_name)
      child = Vidalia::Object.new(:name => child_name, :parent => @id)
    end
  
    
  end

end
