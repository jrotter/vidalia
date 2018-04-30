module Vidalia
  # Represents an entity stored in a data source accessed through an interface,
  # provides user-specified methods to read from and write to the data source,
  # and serves as the primary adapter between the data source's structures and
  # Vidalia elements
  class Entity
    private

    # Helper method to create an inferred element
    # @param [Symbol or String] name the name to create the element with
    # @param [Symbol] iv_sym the symbol referring to the instance variable
    #   to infer the element from
    # @return [Vidalia::Element] the inferred element
    def default_element(name, iv_sym)
      def_block = proc do |ent| # Use the DSL to create default get and set
        get { ent.instance_variable_get iv_sym }
        set { |value| ent.instance_variable_set iv_sym, value }
      end
      Element.new(name, parent_entity: self, definition_block: def_block)
    end

    public

    # Creates a new entity
    #
    # @param [Module] connection_mixin a module containing the open and close
    #   methods for connecting to and disconnecting from a data source;
    #   intended to come from a Vidalia::Interface
    # @param [Proc] definition_block a block defining an entity's methods and
    #   elements with the Vidalia DSL
    #
    # @todo maybe require both of these parameters so they aren't kwargs
    def initialize(connection_mixin: nil, definition_block: nil)
      @elements = {}
      singleton_class.class_exec(connection_mixin) { |m| include m }
      instance_eval(&definition_block)
    end

    # Used either as a DSL method for defining an element or used to recall an
    # element based off of an existing definition or create a new element based
    # on inferred entity instance variable names
    #
    # @param [Symbol or String] name the name of the element to be recalled or
    #   defined
    # @param [Proc] block the block used as the element defintion if an element
    #   is to be defined
    #
    # @return [Vidalia::Element] the element defined, recalled, or inferred
    #
    # @todo How do I make sure elements don't clash with previously existing
    #   instance variable names?
    #
    # @example DSL usage
    #   entity 'My Entity' do
    #     element 'My Element' do |ent|
    #       get { ent.instance_variable_get :@my_element }
    #       set { |val| ent.instance_variable_set :@my_element, val }
    #     end
    #   end
    #
    # @example Using the methods defined in the DSL
    #   ent = Vidalia::Interface.get('My Interface').entity('My Entity')
    #   ent.element('My Element').set 'hi'
    #   puts ent.element('My Element').get # prints 'hi'
    def element(name, &block)
      vid_name = name.to_vidalia_name
      if block # Define a new element
        @elements[vid_name] = Element.new(name, parent_entity: self,
                                                definition_block: block)
      elsif @elements[vid_name] # Element has been defined previously
        @elements[vid_name]
      elsif instance_variables.index(iv_sym = "@#{vid_name}".to_sym)
        # Infer element from the parent entity's instance variables
        default_element(name, iv_sym)
      else # Element not defined and can't infer from instance variables
        raise Vidalia::NoElementError.new(self, name)
      end
    end

    # Returns +true+ to indicate this class handles missing methods
    def respond_to_missing?
      true
    end

    # DSL method that defines a singleton method on the entity, implicitly
    # calling the mixed in open and close methods and passing in the resulting
    # connection as the first argument
    #
    # @todo consider what should happen if close was never defined
    # @todo consider the following verification:
    #   Assert meth_sym was defined
    #   Assert meth can take a connection argument
    #   Assert args[1..-1] == number of args - 1 (for the connection arg)
    #
    # @example DSL usage (+read+ and +update+)
    #   interface 'My Interface' do |inter|
    #     entity 'My Entity' do
    #       read do |connection, id|
    #         @id = id
    #         res = connection.query id # Get data from your db connection
    #         @name = res.name
    #       end
    #
    #       update do |connection, new_name|
    #         # Write to db record with the new name value
    #         res = connection.update(@id, new_name)
    #       end
    #     end
    #   end
    #
    # @example Using the methods defined in the DSL
    #   ent = Vidalia::Interface.get('My Interface').entity('My Entity')
    #   ent.read('12345')            # param here is the id in the db connection
    #   puts ent.element('Name').get # will print the name read from the db
    #   ent.update('The New Name')   # will update the record in the db
    #   puts ent.element('Name').get # will still print the old name
    #   ent.read('12345')            # updates entity with db's current values
    #   puts ent.element('Name').get # will print 'The New Name'
    def method_missing(meth_sym, *_args, &block)
      define_singleton_method(meth_sym) do |*args|
        connection = open
        result = block.yield(connection, *args)
        close connection
        # Return the result of the block (the interesting part of the method)
        result
      end
    end
  end
end
