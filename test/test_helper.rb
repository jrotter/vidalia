require 'simplecov'
# Remove test files from code coverage report
SimpleCov.profiles.define 'test' do
  add_filter 'test'
end
SimpleCov.start 'test'

require 'minitest/autorun'
require_relative '../lib/vidalia'

module Vidalia
  class InterfaceDefinition
    def self.reset
      @@interfaces = []
    end
  end
  class Artifact
    attr_reader :parent, :children
  end
  class Element
    attr_reader :logtext
  end
  class Mysql
    attr_accessor :printable_name
    attr_accessor :host
    attr_accessor :port
    attr_accessor :database_name
    attr_accessor :username
    attr_accessor :password
    attr_accessor :sslca
    def open_connection
      Thread.current[:open_mysql_connection] = true
    end
    def launch_query_command(query:)
      raise "KABOOM" if query == "KABOOM"
      query
    end
    def close_connection
      Thread.current[:close_mysql_connection] = true
    end
  end
end
