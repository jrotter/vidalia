module Vidalia

  class Object

    attr_reader :name,
      :aliases
  
    # Create a Vidalia object
    #
    # *Options*
    #
    # +name+:: specifies the name of the object
    # +aliases+:: specifies an array of aliases for the object
    #
    # *Example*
    #
    #   Vidalia::Object.new(
    #     :name => "Patient Medication", 
    #     :aliases => ["Medication", "Med", "patient_medication"]
    #   )
    #
    def initialize(opts = {})
      o = {
        :name => nil,
        :aliases => []
      }.merge(opts)

      @name = o[:name]
      raise "Vidalia::Object requires a name to be defined" unless @name
      raise "Vidalia::Object requires name to be a string" unless @name.is_a?(String)

      @aliases = o[:aliases]
      if @aliases
        raise "Vidalia::Object requires aliases to be an array" unless @aliases.is_a?(Array)
        @aliases.each do |my_alias|
          raise "Vidalia::Object requires each alias in the array to be a string" unless my_alias.is_a?(String)
        end
      end
      
      @elements = Hash.new
      @object_test = nil
    end

  
    # Add this Object to an Interface
    #
    # If the specified interface does not exist, it will be added
    #
    # *Options*
    #
    # +interface+:: specifies the Interface to add this object to, either via the String name or the Vidalia::Interface object
    #
    # *Example*
    #
    #   myobject = Vidalia::Object.new(
    #     :name => "Blog Post" 
    #   )
    #   myobject.add_to_interface("Blogger API")
    #
    def add_to_interface(interface)

      if interface
        case
        when interface.is_a?(String)
          int = Vidalia::Interface.find(interface)
          unless int
            int = Vidalia::Interface.new(:name => interface)
          end
          int.add_object(self)
        when interface.is_a?(Vidalia::Interface)
          interface.add_object(self)
        else
          raise "Input value must be a String or an Interface object when adding this Object to an Interface"
        end
      else
        raise "Input value cannot be nil when when adding this Object to an Interface"
      end
      self
    end


    # Add a Element to the current Object
    #
    # *Options*
    #
    # +element+:: specifies the Element object to be added
    #
    # *Example*
    #
    #   object = Vidalia::Object.new(
    #     :name => "Patient Medication", 
    #     :aliases => ["Medication", "Med", "patient_medication"]
    #   )
    #   element = Vidalia::Element.new(
    #     :name => "Name",
    #     :text => "medication name"
    #   )
    #   object.add_element(element)
    #
    def add_element(element)

      if element
        if element.is_a?(Vidalia::Element)
          @elements[element.name] = element
          if element.aliases
            element.aliases.each do |my_alias|
              @elements[my_alias] = element
            end
          end
        else
          raise "Element must be a Vidalia::Element when being adding to a Object"
        end
      else
        raise "Element must be specified when adding a Element to an Object"
      end
      self
    end

  
    # Retrieve a Element object by name or alias.
    #
    # *Options*
    #
    # +name+:: specifies the name or alias of the element
    #
    # *Example*
    #
    #   myobject.element("ZIP Code")
    def element(requested_name)
      element = @elements[requested_name] 
      if element
        return element
      else
        raise "Invalid element name requested: \"#{requested_name}\""
      end
    end
    
  end

end
