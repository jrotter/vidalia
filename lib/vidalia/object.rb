module Vidalia

  class Object < Artifact
 
    attr_reader :name, :parent

    @@methodlist = Hash.new

    # Define an Object
    #
    # This routine takes a Vidalia::InterfaceDefinition and adds an Object
    # definition to the associated Interface.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the Object
    # +interface+:: specifies the Vidalia::InterfaceDefinition that the Object is associated with
    #
    # +block+:: specifies the block of code to be run when the Object is initialized
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def self.define(opts = {}, &block)
      Vidalia::ObjectDefinition.new(opts,&block)
    end


    # Create an Object (inherited from Vidalia::Artifact)
    #
    # Initializes a Vidalia::Object using the data set in 
    # Vidalia::Object.define.  If such data does not exist, this routine will 
    # error out.  This ensures that all Objects have been predefined.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the Object
    # +parent+:: specifies the parent object
    #
    # *Example*
    #
    #   blog_post = Vidalia::Object.new("Blog Post")
    #
    def initialize(opts = {})
      o = {
        :name => nil,
        :parent => nil,
        :definition => nil
      }.merge(opts)

      @type = Vidalia::Object
      super
    end


    # Retrieve a child Element of this Object by name
    #
    # *Options*
    #
    # This method takes one parameter:
    # +name+:: specifies the name of the child Element
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def element(name)
      Vidalia::checkvar(name,String,self.class.ancestors,"name")
      child = get_child(name)
      unless child
        # Child does not yet exist.  Create it.
        child = Vidalia::Element.new(
          :name => name,
          :parent => self,
          :definition => @source_artifact.get_child(name)
        )
      end
      child
    end
  
    
    # Define a method to act on a given Object
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the method
    # +token+:: specifies the Vidalia::ArtifactToken of the Object
    #
    # *Example*
    #
    #   
    # 
    def self.add_method(opts = {},&block)
      o = {
        :name => nil,
        :token => nil
      }.merge(opts)
      Vidalia::checkvar(o[:name],String,self.class.ancestors,"name")
      Vidalia::checkvar(o[:token],Vidalia::Identifier,self.class.ancestors,"name")
      @@methodlist[o[:name]] = [] unless @@methodlist[o[:name]]
      method_data = Hash.new
      method_data["name"] = o[:name]
      method_data["token"] = o[:token]
      method_data["block"] = block
      @@methodlist[o[:token]] << method_data
    end
   
 
    # Add a pre-defined instance method to this Class
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the method
    # +token+:: specifies the Vidalia::ArtifactToken of the Object
    #
    # *Example*
    #
    #   # Note that both the "Blog API" and "Blog Post" Objects must be predefined
    #   blog_api = Vidalia::Object.new("Blog API")
    #   blog_post = Vidalia::Object.new("Blog Post")
    #   blog_post.set_parent(blog_api)
    # 
    def self.define_method_for_object(opts = {},&block)
      o = {
        :name => nil
      }.merge(opts)
      Vidalia::checkvar(o[:name],String,self.class.ancestors,"name")
      block = o[:block]
      define_method o[:name], &block
    end
    
  end

end
