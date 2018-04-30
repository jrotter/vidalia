require 'vidalia/interface'
require 'vidalia/entity'
require 'vidalia/element'
require 'vidalia/mysql'
require 'vidalia/name'

# Provides core classes and module level functions for working with Vidalia
# functionality
module Vidalia
  class << self
    # @return [Hash] internal registry of Vidalia::Interface instances
    attr_accessor :interfaces
  end

  @interfaces = {}

  # Configure the logging routine to be used by Vidalia for this thread
  # The routine you store here can be invoked by Vidalia.log
  #
  # @param [Proc] block the code block to be called whenever Vidalia needs to
  #   invoke a logger; this block should take a string followed by an optional
  #   hash as its parameters
  #
  # @example
  #   Vidalia.set_logroutine { |string, opts| MyLogger::write(string,opts) }
  def self.set_logroutine(&block)
    Thread.current[:vidalia_logroutine] = block
  end

  # Write to the Vidalia log
  # The log can be predefined by Vidalia.set_logroutine
  #
  # @param [String] string the string to write to the Vidalia log
  # @param [Hash] opts a hash containing parameters to the Vidalia logging
  #   function
  #
  # @example
  #   Vidalia.log("Everything is fine - no bugs here", style: :fatal_error)
  def self.log(string, opts = {})
    Thread.current[:vidalia_logroutine].call(string, opts)
  end

  class Error < StandardError
  end

  class NoInterfaceError < Error
    def initialize(name)
      super "undefined vidalia interface `#{name}'"
    end
  end

  class NoEntityError < Error
    def initialize(interface, ent_name)
      super "entity `#{ent_name}' not defined for interface " \
        "#{interface.inspect}"
    end
  end

  class NoElementError < Error
    def initialize(entity, elem_name)
      super "element `#{elem_name}' not defined for object " \
        "#{entity.inspect}"
    end
  end
end
