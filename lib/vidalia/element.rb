module Vidalia

  class Element
  
    attr_reader :name,
      :aliases
  
    # Create a new element object
    #
    # *Options*
    #
    # +name+:: the name used to identify this element
    # +logtext+:: the text to be used when referring to this element in logs
    # +aliases+:: specifies an array of aliases for the element
    # +parent+:: specifies the parent Object of this element
    #
    # *Example*
    #
    #   myobject = Vidalia::Object.new(
    #     :name => "Blog Post"
    #   )
    #   newelement = Vidalia::Element.new(
    #     :name => "Subject",
    #     :logtext = "blog post subject",
    #     :parent => myobject
    #   )
    def initialize(opts = {})
    o = {
        :name => nil,
        :logtext => nil,
        :aliases => [],
        :parent => nil
      }.merge(opts)
      @name = o[:name]
      @logtext = o[:logtext]
      @aliases = o[:aliases]
      @parent = o[:parent]

      if @name
        unless @name.is_a?(String)
          raise "Name must be a String when adding a element"
        end
      else
        raise "Name must be specified when adding a element"
      end
      if @logtext
        unless @logtext.is_a?(String)
          raise "Logtext must be a String when adding a element"
        end
      else
        raise "Logtext must be specified when adding a element" 
      end
      if @aliases
        unless @aliases.is_a?(Array)
          raise "Vidalia::Element requires aliases to be an array"
        end
        @aliases.each do |my_alias|
          raise "Vidalia::Element requires each alias in the array to be a string" unless my_alias.is_a?(String)
        end
      end

      if @parent
        if @parent.is_a? Vidalia::Object
          add_to_object(@parent)
        else
          raise "Parent specified for Element \"#{@name}\", but parent object type unrecognized."
        end
      end

    end


    # Add this Element to an Object
    #
    # *Options*
    #
    # +object+:: specifies a Vidalia::Object to add this Element to
    #
    # *Example*
    #
    #   blog_post = Vidalia::Object.new(
    #     :name => "Blog Post"
    #   )
    #   subject = Vidalia::Element.new(
    #     :name => "Subject",
    #     :logtext = "subject"
    #   )
    #   subject.add_to_object(blog_post)
    #
    def add_to_object(object)

      if object
        case
        when object.is_a?(Vidalia::Object)
          object.add_element(self)
        else
          raise "Input value must be an Object when adding this Element to a Object"
        end
      else
        raise "Input value cannot be nil when adding this Element to a Object"
      end
      self
    end


    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def get(opts = {})
      verify_element_presence("get")
      return @get_method.call(opts)
    end

  
    # Set the value for this element
    #
    # *Options*
    #
    # +value+:: specifies the value that this element will be set to
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def set(value,opts = {})
      verify_element_presence("set")
      @set_method.call(value,opts)
    end

  
    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def retrieve(opts = {})
      verify_element_presence("retrieve")
      return @retrieve_method.call(opts)
    end

  
    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def update(value,opts = {})
      verify_element_presence("update")
      @update_method.call(value,opts)
    end

  
    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def confirm(value,opts = {})
      verify_element_presence("confirm")
      return @confirm_method.call(value,opts)
    end

  
    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def verify(value,opts = {})
      verify_element_presence("verify")
      @verify_method.call(value,opts)
    end
 
 
    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_get(&block)
      @get_method = block
  
      add_generic_retrieve() unless @retrieve_method
      add_generic_confirm() unless @confirm_method
      add_generic_verify() unless @verify_method
      if @set_method != nil
        add_generic_update unless @update_method
      end 
    end

  
    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_set(&block)
      @set_method = block
    
      if @get_method != nil
        add_generic_update() unless @update_method
      end 
    end

  
    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_update(&block)
      @update_method = block
    end


    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_retrieve(&block)
      @retrieve_method = block
    end


    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_verify(&block)
      @verify_method = block
    end


    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_confirm(&block)
      @confirm_method = block
    end
 

    # Method description
    #
    # Depends on get, retrieve, set 
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_generic_update()
      add_update { |value,opts|
        new_value = value
        found_value = retrieve()
        if new_value == found_value
          capital_text = @logtext
          capital_text[0] = capital_text[0].capitalize
          Vidalia.log("#{capital_text} is already set to \"#{new_value}\"")
        else
          Vidalia.log("Entering #{@logtext}: \"#{new_value}\" (was \"#{found_value}\")")
          set(new_value,opts)
        end
      }
    end

  
    # Method description
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_generic_retrieve()
      add_retrieve { |opts|
        get(opts)
      }
    end

 
    # Method description
    #
    # Depends on get, retrieve 
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_generic_verify()
      add_verify { |value,opts|
        found_value = retrieve()
        if value == found_value
          Vidalia.log("Verified #{@logtext} to be \"#{value}\"")
        else
          raise "Expected #{@logtext} to be \"#{value}\", but found \"#{found_value}\" instead"
        end
        true
      }    
    end
 
 
    # Method description
    #
    # Depends on get, retrieve 
    #
    # *Options*
    #
    # +option+:: specifies something
    #
    # *Example*
    #
    #   $$$ Need an example $$$
    def add_generic_confirm()
      add_confirm { |value,opts|
        retval = false
        found_value = retrieve()
        if value == found_value
          retval = true
        end
        retval
      }        
    end
 
 
  end

end
