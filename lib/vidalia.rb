require 'vidalia/interface'
require 'vidalia/object'
require 'vidalia/element'

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


end
