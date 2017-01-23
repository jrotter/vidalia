module Vidalia

  class Artifact
 
    attr_reader :name, :parent

    # List of all master Artifact definitions
    @@definitions = Hash.new

    # Define an Artifact
    #
    # This routine saves the specified Artifact parameters to the master list 
    # of Artifacts.  When a user instantiates a Vidalia::Artifact, it will 
    # initialize the object with this data and run the specified block of code.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the Interface
    # +block+:: specifies the block of code to be run when the Interface object is initialized
    #
    # *Example*
    #
    #   Vidalia::Artifact.define(:name => "Blog API") {
    #     @db_password = ENV['BLOG_DB_PASSWORD']
    #     @db_userid = ENV['BLOG_DB_PASSWORD']
    #     @db_ip = ENV['BLOG_DB_IP']
    #     @db_port = ENV['BLOG_DB_PORT']
    #   }
    #
    #
    def self.define(opts = {}, &block)
      o = {
        :name => nil,
      }.merge(opts)

      Vidalia::checkvar(o[:name],String,self.class.ancestors,":name")

      objectdata = Hash.new
      o.each do |key,index|
        objectdata[key] = index
      end
      objectdata[:initialization_block] = block
      @@definitions[o[:name]] = objectdata
      objectdata
    end


    # Get Vidalia master Artifact data
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: a string specifying the name of the Artifact
    #
    # *Example*
    #
    #   Vidalia::Artifact.get_definition_data("Blog API")
    #
    def self.get_definition_data(name)

      Vidalia::checkvar(name,String,self.class.ancestors,"name")
      @@definitions[name]
    end

  
    # Create an Artifact
    #
    # Initializes a Vidalia::Artifact using the data set in Vidalia::Artifact.define.  If such data
    # does not exist, this routine will error out.  This ensures that all Artifacts have been
    # predefined.
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: specifies the name of the Artifact
    #
    # *Example*
    #
    #   blog_api = Vidalia::Interface.new("Blog API")
    #
    def initialize(name)

      @children = Hash.new
      @name = name
      Vidalia::checkvar(name,String,self.class.ancestors,"name")

      objectdata = Vidalia::Artifact.get_definition_data(@name)

      puts "Objectdata == #{objectdata}\n"
      unless objectdata
        raise "Cannot find definition data for Vidalia::Artifact name \"#{name}\".  Make sure you've defined it first!"
      end

      block = objectdata[:initialization_block]
      self.instance_eval &block
    end


    # Find an Artifact definition by name
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: specifies the name of the Artifact to search for
    #
    # *Example*
    #
    #   blog_api = Vidalia::Artifact.find_definition("Blog API")
    #
    def self.find_definition(name)
      @@interface_definitions[name]
    end

  
    # Add a child object to this Artifact
    #
    # *Options*
    #
    # This method takes one parameter:
    # +object+:: specifies a Vidalia::Artifact object to be added as a child
    #
    # *Example*
    #
    #   # Note that both the "Blog API" and "Blog Post" Artifacts must be predefined
    #   blog_api = Vidalia::Artifact.new("Blog API")
    #   blog_post = Vidalia::Artifact.new("Blog Post")
    #   blog_api.add_child(blog_post)
    #
    def add_child(object)
      Vidalia::checkvar(object,Vidalia::Artifact,self.class.ancestors,"object")
      @children[object.name] = object
      object
    end


    # Get a child of this Artifact
    #
    # *Options*
    #
    # This method takes one parameter:
    # +name+:: specifies the name of a child of this Artifact
    #
    # *Example*
    #
    #   # Note that both the "Blog API" and "Blog Post" Artifacts must be predefined
    #   blog_api = Vidalia::Artifact.new("Blog API")
    #   blog_post = Vidalia::Artifact.new("Blog Post")
    #   blog_api.add_child(blog_post)
    #   my_child = blog_api.get_child("Blog Post")
    #
    def get_child(name)
      Vidalia::checkvar(name,String,self.class.ancestors,"name")
      @children[name]
    end


    # Set the parent object of this Artifact
    #
    # *Options*
    #
    # This method takes one parameter
    # +object+:: specifies a Vidalia::Artifact object to be set as the parent
    #
    # *Example*
    #
    #   # Note that both the "Blog API" and "Blog Post" Artifacts must be predefined
    #   blog_api = Vidalia::Artifact.new("Blog API")
    #   blog_post = Vidalia::Artifact.new("Blog Post")
    #   blog_post.set_parent(blog_api)
    # 
    def set_parent(object)
      Vidalia::checkvar(object,Vidalia::Artifact,self.class.ancestors,"object")
      @parent = object
      object
    end
  
    
  end

end
