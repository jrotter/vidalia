require 'vidalia/interface_definition'
require 'vidalia/object_definition'
require 'vidalia/element_definition'
require 'vidalia/artifact'
require 'vidalia/interface'
require 'vidalia/object'
require 'vidalia/element'
require 'vidalia/dsl'
require 'vidalia/mysql'

# [cat]  something
# something else
#
#
# * Top level comment about Vidalia

module Vidalia

  # Configure the logging routine to be used by Vidalia for this thread.
  #
  # The routine you store here can be invoked by Vidalia.log
  #
  # *Options*
  #
  # +&block+:: specifies the code block to be called whenever Vidalia needs to invoke a logger.  This block should take a string followed by an optional hash as its parameters.
  #
  # *Example*
  #
  #   Vidalia.set_logroutine { |string,opts|
  #     MyLogger::write(string,opts)
  #   }
  def Vidalia.set_logroutine(&block)
    Thread.current[:vidalia_logroutine] = block
  end 

 
  # Write to the Vidalia log
  #
  # The log can be predefined by Vidalia.set_logroutine
  #
  # *Options*
  #
  # +string+:: specifies the string to write to the Vidalia log
  # +opts+:: specifies a hash containing parameters to the Vidalia logging function
  #
  # *Example*
  #
  #   Vidalia.log("Everything is fine - no bugs here.",:style => fatal_error)
  def Vidalia.log(string,opts = {})
    return Thread.current[:vidalia_logroutine].call(string,opts)
  end


  # Check the type and existence of a variable
  #
  # *Options*
  #
  # +thing+:: specifies the veriable to check
  # +thingtype+:: specifies the desired type of the variable data
  # +procclass+:: specifies the class of the calling method
  # +procname+:: specifies the name of the calling method
  #
  # *Example*
  #
  #   Vidalia.log("Everything is fine - no bugs here.",:style => fatal_error)
  def Vidalia.checkvar(thing,thingtype,procclass,thingname)
    if thing
      unless thing.is_a?(thingtype)
        raise "#{procclass.first}: #{thingname} should be a #{thingtype}, but was a #{thing.class} instead"
      end
    else
      raise "#{procclass.first}: #{thingname} must be specified"
    end
  end


end
