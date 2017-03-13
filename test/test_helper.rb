require 'minitest/autorun'
require 'vidalia'

module Vidalia
  class Artifact
    attr_reader :id, :parent_id
  end
  class Element
    attr_reader :logtext
  end
end

