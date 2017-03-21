module Vidalia

  class Object < Artifact
 
    attr_reader :name, :parent, :added_methods

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
    #   $$$ Example needed $$$
    #
    def initialize(opts = {})
      o = {
        :name => nil,
        :parent => nil,
        :definition => nil
      }.merge(opts)

      @type = Vidalia::Object
      super
      @added_methods = Hash.new
      if o[:definition]
        my_def = o[:definition]
        Vidalia::checkvar(my_def,Vidalia::Object,self.class.ancestors,"definition")
        my_def.added_methods.each do |method_name,block|
          @added_methods[method_name] = block
        end
      end
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
    #   $$$ Example needed $$$
    # 
    def add_method(opts = {},&block)
      o = {
        :name => nil
      }.merge(opts)
      Vidalia::checkvar(o[:name],String,self.class.ancestors,"name")
      @added_methods[o[:name]] = block
    end
   
 
    # Add a pre-defined instance method to this Class
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the method
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    # 
    def self.define_method_for_object_class(name)
      Vidalia::checkvar(name,String,self.class.ancestors,"name")
      define_method name.to_sym do |opts = {}|
        if @added_methods[name]
          @added_methods[name].call(opts)
        else
          raise "Tried to call an Object method that doesn't exist."
        end
      end
    end
    
  end

end
