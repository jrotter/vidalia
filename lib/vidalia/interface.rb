module Vidalia

  class Interface < Artifact

    attr_reader :name, :interface

    # Define an Interface
    #
    # This routine "stores" the defined Interface attributes in a
    # Vidalia::InterfaceDefinition.  Any subsequent call to instantiate
    # an Interface object will copy that object from the InterfaceDefinition.
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: (required) specifies the name of the interface
    # +block+:: (optional) specifies a block of code to be run when the interface object is initialized
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
      Vidalia::InterfaceDefinition.new(opts,&block)
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
    #
    # *Example*
    #
    #   blog_api = Vidalia::Interface.new("Blog API")
    #
    def initialize(opts = {}, &block)
      o = {
        :name => nil,
        :definition => nil
      }.merge(opts)

      @type = Vidalia::Interface 
      super
    end


    # Retrieve a child Object of this Interface by name
    #
    # *Options*
    #
    # This method takes one parameter:
    # +name+:: specifies the name of the child Object
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def object(name)
      Vidalia::checkvar(name,String,self.class.ancestors,"name")
      child = get_child(name)
      unless child
        # Child does not yet exist.  Create it.
        child = Vidalia::Object.new(
          :name => name,
          :parent => self,
          :definition => @source_artifact.get_child(name)
        )
      end
      child
    end
  
    
    # Get an Interface object by name
    #
    # *Options*
    #
    # This method takes one parameter:
    # +name+:: (required) specifies the name of the Interface
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def self.get(name)
      return Vidalia::Interface.new(
        :name => name,
        :definition => Vidalia::InterfaceDefinition.find(name)
      )
    end


  end

end
