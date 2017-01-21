module Vidalia

  class Artifact
 
    attr_reader :name, :parent

    # List of all master Artifact definitions
    @@definitions = Hash.new

    # Define an Artifact
    #
    # This routine saves the specified Artifact parameters to the master list of Artifacts.
    # When a user instantiates a Vidalia::Artifact, it will initialize the object with
    # this data and run the specified block of code.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the interface
    # +block+:: specifies the block of code to be run when the interface object is initialized
    #
    # *Example*
    #
    #   Vidalia::Artifact.define(:name => "Blog API") {
    #     @db_password = get_parameters_for_database_call(ENV['BLOG_DB_PASSWORD'])
    #     @db_userid = get_parameters_for_database_call(ENV['BLOG_DB_PASSWORD'])
    #     @db_ip = get_parameters_for_database_call(ENV['BLOG_DB_IP'])
    #     @db_port = get_parameters_for_database_call(ENV['BLOG_DB_PORT'])
    #   }
    #
    #
    def self.define(opts = {}, &block)
      o = {
        :name => nil,
      }.merge(opts)

      raise "Vidalia::Artifact.define requires :name as a parameter" unless o[:name]
      raise "Vidalia::Artifact.define requires :name to be a string" unless o[:name].is_a?(String)

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
    # +name+:: a string specifying the name of the Artifact
    #
    # *Example*
    #
    #   Vidalia::find_master_object_data("Blog API")
    #
    def self.get_definition_data(name)

      raise "Vidalia::Object.get_definition_data requires a name to be defined" unless name
      raise "Vidalia::Object.get_definition_data requires name to be a string" unless name.is_a?(String)

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
    # +name+:: specifies the name of the artifact
    #
    # *Example*
    #
    #   blog_api = Vidalia::Interface.new("Blog API")
    #
    def initialize(name)

      @children = Hash.new
      @name = name
      raise "Vidalia::Artifact name must be specified" unless @name
      raise "Vidalia::Artifact name must be a string" unless @name.is_a?(String)

      objectdata = Vidalia::Artifact.get_definition_data(@name)

      puts "Objectdata == #{objectdata}\n"
      unless objectdata
        raise "Cannot find definition data for Vidalia::Artifact name \"#{name}\".  Make sure you've defined it first!"
      end

      block = objectdata[:initialization_block]
      self.instance_eval &block
    end


    # Find an interface definition by name
    #
    # *Options*
    #
    # +name+:: specifies the name of the interface to search for
    #
    # *Example*
    #
    #   blog_api = Vidalia::Interface.find("Blog API")
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
    #   # Note that both the "Blog API" and "Blog Post" artifacts must be predefined
    #   blog_api = Vidalia::Artifact.new("Blog API")
    #   blog_post = Vidalia::Artifact.new("Blog Post")
    #   blog_api.add_child(blog_post)
    #
    def add_child(object)
      unless object.is_a?(Vidalia::Artifact)
        raise "Vidalia::Artifact.add_child requires object parameter to be a Vidalia::Artifact"
      end
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
    #   # Note that both the "Blog API" and "Blog Post" artifacts must be predefined
    #   blog_api = Vidalia::Artifact.new("Blog API")
    #   blog_post = Vidalia::Artifact.new("Blog Post")
    #   blog_api.add_child(blog_post)
    #   my_child = blog_api.get_child("Blog Post")
    #
    def get_child(name)
      unless name.is_a?(String)
        raise "Vidalia::Artifact.get_child requires object parameter to be a String"
      end
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
    #   # Note that both the "Blog API" and "Blog Post" artifacts must be predefined
    #   blog_api = Vidalia::Artifact.new("Blog API")
    #   blog_post = Vidalia::Artifact.new("Blog Post")
    #   blog_post.set_parent(blog_api)
    # 
    def set_parent(object)
      unless object.is_a?(Vidalia::Artifact)
        raise "Vidalia::Artifact.set_parent requires object parameter to be a Vidalia::Artifact"
      end
      @parent = object
      object
    end
  
    
  end

end
