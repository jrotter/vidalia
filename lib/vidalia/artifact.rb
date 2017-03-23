module Vidalia

  class Artifact
 
    attr_reader :name, :parent, :init_block

    # Create an Artifact
    #
    # Initializes a Vidalia::Artifact using the data set in Vidalia::Artifact.define.  If such data
    # does not exist, this routine will error out.  This ensures that all Artifacts have been
    # predefined.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: (required) specifies the name of the Interface
    # +parent+:: (required) specifies the Vidalia::Identifier of the parent object
    # +definition+:: (optional) specifies the Vidalia::Artifact contained by the artifact's definition
    #
    # *Example*
    #
    #   $$$ Example needed $$$
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
      @children = Hash.new

      if o[:parent]
        # Add myself as a child of my parent
        Vidalia::checkvar(o[:parent],Vidalia::Artifact,self.class.ancestors,"parent")
        @parent = o[:parent]
        @parent.add_child(self)
      else
        # Just kidding.  I'm an orphan.  :(
        @parent = nil
      end

      @source_artifact = o[:definition]

      if @source_artifact
        # If this is an instantiation of a definition

        Vidalia::checkvar(@source_artifact,Vidalia::Artifact,self.class.ancestors,"definition")

        # Copy the initialization block and run it if defined
        @init_block = @source_artifact.init_block
        if @init_block
          block = @init_block
          instance_eval(&block)
        end
      else
        # If this is only a definition

        # Store the initialization block
        @init_block = block
      end
    end


    # Copy an Artifact from another Artifact
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
      Vidalia::checkvar(source,Vidalia::Artifact,self.class.ancestors,"source")
      @name = source.type
      @type = source.type
      @init_block = source.init_block
      super
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
      object.set_parent(self)
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
    #   $$$ Example needed $$$
    #
    def get_child(name)
      Vidalia::checkvar(name,String,self.class.ancestors,"name")
      @children[name]
    end


    # Get a the number of children of this Artifact
    #
    # *Options*
    #
    # This method takes no parameters.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def number_of_children
      @children.size
    end
  
    
    # Set the parent of this Artifact
    #
    # *Options*
    #
    # This method takes one parameter:
    # +parent+: specifies the parent object of this Artifact
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def set_parent(parent)
      @parent = parent
    end
  
    
  end

end
