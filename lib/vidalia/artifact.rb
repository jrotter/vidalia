module Vidalia

  class Artifact
 
    attr_reader :name, :parent

    # Create an Artifact
    #
    # Initializes a Vidalia::Artifact using the data set in Vidalia::Artifact.define.  If such data
    # does not exist, this routine will error out.  This ensures that all Artifacts have been
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
    def initialize(opts = {},&block)
      o = {
        :name => nil,
        :parent => nil,
        :definition => nil
      }.merge(opts)

      Vidalia::checkvar(o[:name],String,self.class.ancestors,"name")
      @name = o[:name]

      @type = Vidalia::Artifact unless @type

      @parent = o[:parent] # Can be nil
      @children = []
      if o[:parent]
        Vidalia::checkvar(o[:parent],Vidalia::Artifact,self.class.ancestors,"parent")
        @parent.children << self
      end

      @init_block = block
      block.call() unless o[:definition]
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
