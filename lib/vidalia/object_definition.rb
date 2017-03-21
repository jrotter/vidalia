module Vidalia

  class ObjectDefinition

    attr_reader :name, :parent, :children, :object

    @@defined_method_names = {}

    # Create an Object Definition
    #
    # Under the covers, the ObjectDefinition will create an associated
    # Object definition.  Any instantiated Object under the parent Interface
    # will be copied from this master copy.
    #
    # *Options*
    #
    # Takes two parameters:
    # Takes a hash as input where the current options are:
    # +name+:: (required) specifies the name of the Object
    # +parent+:: (required) specifies the name of the parent Interface
    # Takes a block to be executed at initialization time
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def initialize(opts = {}, &block)
      o = {
        :name => nil,
        :parent => nil
      }.merge(opts)

      Vidalia::checkvar(o[:name],String,self.class.ancestors,"name")
      Vidalia::checkvar(o[:parent],Vidalia::InterfaceDefinition,self.class.ancestors,"parent")

      o[:parent] = o[:parent].interface
      @object = Vidalia::Object.new(o,&block)
    end


    # Define a method to act on a defined Object
    #
    # Define a method that any Vidalia::Object can run and save the method code in
    # the Vidalia::Object represented with this definition
    #
    # *Options*
    #
    # Takes a hash as input where the current options are:
    # +name+:: specifies the name of the method
    # Takes a block that defines the code to run for that method
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    # 
    def add_method(opts = {},&block)
      o = {
        :name => nil
      }.merge(opts)

      name = o[:name]
      Vidalia::checkvar(name,String,self.class.ancestors,"name")

      # Save the method code in the Vidalia::Object represented with this definition
      @object.add_method(o,&block)

      # Define a method that any Vidalia::Object can run
      unless @@defined_method_names[name]
        @@defined_method_names[name] = true
        Vidalia::Object.define_method_for_object_class(name)
      end

    end
   
  end

end
