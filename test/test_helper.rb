require 'minitest/autorun'
require 'vidalia'

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
end

