module Vidalia

  class InterfaceDefinition

    @@interfaces = []
    attr_reader :name, :parent, :interface

    # Create an Interface Definition
    #
    # Under the covers, the InterfaceDefinition will create or find the
    # associated Interface definition.  Any instantiated Interface will
    # be copied from this master copy.
    #
    # *Options*
    #
    # Takes two parameters:
    # Takes a hash as input where the current options are:
    # +name+:: (required) specifies the name of the Interface
    # Takes a block to be executed at initialization time
    #
    # *Example*
    #
    #   blog_api = Vidalia::InterfaceDefinition.new("Blog API") {
    #     @db_password = ENV['BLOG_DB_PASSWORD']
    #     @db_userid = ENV['BLOG_DB_PASSWORD']
    #     @db_ip = ENV['BLOG_DB_IP']
    #     @db_port = ENV['BLOG_DB_PORT']
    #   }
    #
    def initialize(opts = {}, &block)
      o = {
        :name => nil
      }.merge(opts)

      Vidalia::checkvar(o[:name],String,self.class.ancestors,"name")

      found = false
      @@interfaces.each do |i|
        if i.name == o[:name]
          @interface = i
        end
      end

      # It's OK to "define" an Interface that has already been defined
      unless @interface
        opts[:definition] = true
        @interface = Vidalia::Interface.new(opts,&block)
        @@interfaces << @interface
      end
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
