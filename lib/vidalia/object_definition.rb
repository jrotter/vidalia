module Vidalia

  class ObjectDefinition

    attr_reader :name, :parent, :children, :object

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
      o[:definition] = true
      @object = Vidalia::Object.new(o,&block)
    end


  end

end
