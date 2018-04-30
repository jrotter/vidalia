# DSL method to build a new Vidalia::Interface
#
# @param [String or Symbol] name the name of the interface, to be converted
# to a String with {Symbol#to_vidalia_name} or {String#to_vidalia_name}
# @param [Proc] block the block to run on the newly created Vidalia::Interface
#
# @return [Vidalia::Interface] the newly created interface
#
# @todo a way to re-open an interface to define more entities in it
# @note test considerations - what if user tries to reopen an interface and
#   define open and close a second time?
#
# @example DSL usage
#   interface 'My Interface' do |inter|
#     open { ... }
#     close { ... }
#     entity 'My Entity' do
#       ...
#     end
#   end
def interface(name, &block)
  vid_name = name.to_vidalia_name
  inter = Vidalia::Interface.new
  Vidalia.interfaces[vid_name] = inter

  # Pass the new interface into the block for use by nested entities
  inter.instance_exec(inter, &block)
  inter
end

module Vidalia
  # Represents an interface for accessing entities, providing user-specified
  # methods to connect to and disconnect from the interface
  class Interface
    # Creates a new Interface
    # @todo require a name here?
    def initialize
      @entity_defs = {}
      @connection_mixin = Module.new
    end

    # Used either as a DSL method for defining an entity or used to create a
    # new Entity based off an existing entity definition
    #
    # @param [String or Symbol] name the name of the entity to be defined or
    #   created from an existing definiton
    # @param [Proc] block the definition block to run when creating a new
    #   entity
    #
    # @return [Proc or Vidalia::Entity] either the definition provided by the
    #   block parameter or a newly crated Vidalia::Entity based on an existing
    #   definition
    #
    # @example DSL usage to create an Entity definition
    #   interface 'My Interface' do |inter|
    #     ...
    #     entity 'My Entity' do
    #       read { |connection, other_param| ... }
    #       update { |connection, other_param| ... }
    #
    #       element 'My Element' { |ent| ... }
    #     end
    #   end
    #
    # @example Create a new Entity from existing definition
    #   Vidalia::Interface.get('My Interface').entity('My Entity')
    #   >>> returns a Vidalia::Entity
    def entity(name, &block)
      vid_name = name.to_vidalia_name
      if block # Just set up the entity definition
        @entity_defs[vid_name] = block
      elsif (def_block = @entity_defs[vid_name])
        # Create an entity from an existing definition
        Vidalia::Entity.new(connection_mixin: @connection_mixin,
                            definition_block: def_block)
      else
        raise Vidalia::NoEntityError.new(self, vid_name)
      end
    end

    # Finds and returns an existing interface
    #
    # @param [Symbol or String] name the name of the interface to find and get
    #
    # @return [Vidalia::Interface] the interface with the given name
    # @raise [Vidalia::NoInterfaceError] when an interface with the given name is
    #   not defined
    def self.get(name)
      vid_name = name.to_vidalia_name
      inter = Vidalia.interfaces[vid_name]
      raise Vidalia::NoInterfaceError.new(vid_name) unless inter
      inter
    end

    # DSL method for defining a method to open and return a data source
    # connection
    #
    # @param [Proc] block the block to open the connection and return it
    #   end
    #
    # @example DSL usage
    #   interface 'My Interface' do |inter|
    #     open { connection.open }
    #   end
    def open(&block)
      @connection_mixin.send(:define_method, :open, &block)
    end

    # DSL method for definiting a method to close a data source connection
    #
    # @param [Proc] block the block to close the connection; takes the
    #   connection as its only argument
    #
    # @example DSL usage
    #   interface 'My Interface' do |inter|
    #     close { |connection| connection.close }
    #   end
    def close(&block)
      @connection_mixin.send(:define_method, :close, &block)
    end
  end
end
