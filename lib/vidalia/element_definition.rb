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


    # Add a "get" function for a Defined Element
    #
    # This function will be called to obtain the data element value from the
    # Object.  A call to "get" really makes the most sense AFTER obtaining
    # data from the database/API.
    #
    # *Options*
    #
    # Takes a block to be executed when "get" for this defined Element is 
    # invoked.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def add_get(&block)
      if block.arity > 1
        raise "Vidalia::ElementDefinition.add_get block must take a single parameter"
      end
      @element.add_get &block
    end


    # Add a "set" function for a Defined Element
    #
    # This function will be called to set the element's value in the Object.
    # Object.  A call to "set" really makes the most sense BEFORE making an
    # alteration to the Object data via database/API call.
    #
    # *Options*
    #
    # Takes a block to be executed when "set" for this defined Element is 
    # invoked.
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def add_set(&block)
      if block.arity > 1
        raise "Vidalia::ElementDefinition.add_set block must take a single parameter"
      end
      @element.add_set &block
    end

  end

end
