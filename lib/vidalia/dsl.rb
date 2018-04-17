def interface(name, &block)
  inter_def = Vidalia::InterfaceDefinition.new(name: name)
  inter_def.instance_eval &block if block

  # object and element will return Vidalia::Object and Vidalia::Element objects,
  # respectively. Returning a Vidalia::Interface object makes sense here for
  # consistency
  inter_def.interface
end

module Vidalia
  class Interface
    attr_accessor :init_block
  end

  class Object
    attr_accessor :init_block
  end

  class Element
    attr_accessor :init_block
  end

  class InterfaceDefinition
    # Set's the interface's init block
    def init(&block)
      @interface.init_block = block
    end

    def object(name, &block)
      obj_def = Vidalia::ObjectDefinition.new(name: name, parent: self)
      obj_def.instance_eval &block if block
      obj_def.object
    end
  end

  class ObjectDefinition
    def init(&block)
      @object.init_block = block
    end

    def method_missing(meth_id, &block)
      @object.add_method(name: meth_id.to_s, &block)
      # TODO: Honestly not sure why I need this and why add_method doesn't
      # take care of it
      Vidalia::Object.define_method_for_object_class meth_id.to_s
    end

    def element(name, &block)
      elem_def = Vidalia::ElementDefinition.new(name: name, parent: self)
      elem_def.instance_eval &block if block
      elem_def.element
    end
  end

  class ElementDefinition
    def init(&block)
      @element.init_block = block
    end

    def method_missing(meth_id, &block)
      method("add_#{meth_id}".to_sym).call(&block)
    end

  end
end
