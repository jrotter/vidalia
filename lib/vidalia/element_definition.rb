module Vidalia

  class ElementDefinition

    attr_reader :name, :parent, :children, :element

    # Create an Element Definition
    #
    # Under the covers, the ElementDefinition will create an associated
    # Element definition.  Any instantiated Element under the parent Object
    # will be copied from this master copy.
    #
    # *Options*
    #
    # Takes two parameters:
    # Takes a hash as input where the current options are:
    # +name+:: (required) specifies the name of the Element
    # +parent+:: (required) specifies the name of the parent Object
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
      Vidalia::checkvar(o[:parent],Vidalia::ObjectDefinition,self.class.ancestors,"parent")

      o[:parent] = o[:parent].object
      @element = Vidalia::Element.new(o,&block)
    end

  end

end
