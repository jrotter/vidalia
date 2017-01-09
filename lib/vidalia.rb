require 'watir-webdriver'
require 'vidalia/artifact'
require 'vidalia/application'
require 'vidalia/page'
require 'vidalia/region'
require 'vidalia/control'

# [cat]  something
# something else
#
#
# * Top level comment about Vidalia

module Vidalia

  # Global hash containing each Vidalia::Page object indexed by page name (and alias)
  PAGES = Hash.new


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


  # Set the browser object (for the current thread) for Vidalia to use
  #
  # *Options*
  #
  # +browser+:: specifies the browser to store
  #
  # *Example*
  #
  #   Vidalia::set_browser(browser)
  #
  def Vidalia.set_browser(browser)
    Thread.current[:vidalia_browser] = browser
    Thread.current[:vidalia_region] = browser
  end


  # Get the current browser object (for the current thread) from Vidalia
  #
  # Note that inside regions, this may be a Selenium object and not the
  # selenium browser pointer (i.e. a subset of the page instead of the
  # whole page)
  #
  # *Options*
  #
  # none
  #
  # *Example*
  #
  #   Vidalia::browser
  #
  def Vidalia.browser()
    Thread.current[:vidalia_region]
  end


  # Store a Watir object as a filtered browser to be used by controls called within a Region
  #
  # *Options*
  #
  # none
  #
  # *Example*
  #
  #   user_region = Vidalia::Region.new(:name => "User")
  #   user_region.add_filter { |username|
  #     user_list = Vidalia::browser.div(:id => "users")
  #     users = user_list.lis
  #     users.each do |li|
  #       if li.text == username
  #         Vidalia::filter_browser li
  #         break
  #       end
  #     end
  #   }
  #
  def Vidalia.filter_browser(object)()
    Thread.current[:vidalia_region] = object
  end


end
