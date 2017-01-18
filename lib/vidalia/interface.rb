module Vidalia

  class Interface
 
    # List of all defined interfaces 
    @@all = Hash.new

    # Define an interface
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the interface
    #
    # *Example*
    #
    #   blog_api = Vidalia::Interface.new(:name => "Blog API")
    #
    def initialize(opts = {})
      o = {
        :name => nil,
      }.merge(opts)

      @name = o[:name]
      raise "Interface name must be specified" unless @name

      @objects = Hash.new
      @@all[@name] = self
    end


    # Find an interface by name
    #
    # *Options*
    #
    # +name+:: specifies the name of the interface to search for
    #
    # *Example*
    #
    #   blog_api = Vidalia::Interface.find("Blog API")
    #
    def self.find(name)
      @@all[name]
    end

  
    # Add an Object to this Interface
    #
    # *Options*
    #
    # +object+:: specifies a Vidalia::Object
    #
    # *Example*
    #
    #   blog_post = Vidalia::Object.new(:name => "Blog Post")
    #   blog_api.add_object(blog_post)
    #
    def add_object(object)

      if object
        if object.is_a?(Vidalia::Object)
          @objects[object.name] = object
        else
          raise "Object must be a Vidalia::Object when being adding to an interface"
        end
      else
        raise "Object must be specified when adding a object to an interface"
      end
      self
    end


    # Retrieve an object by name.
    #
    # *Options*
    #
    # +name+:: specifies the name of the object
    #
    # *Example*
    #
    #   blog_api.object("Blog Post")
    def object(requested_name)
      object = @objects[requested_name] 
      unless object
        raise "Invalid dataset name requested: \"#{requested_name}\""
      end
      object
    end
  
    
  end

end
