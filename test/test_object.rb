require 'minitest/autorun'
require 'test_helper'

class ObjectTest < Minitest::Test

  def setup
    # Clean up the Interface Definitions
    Vidalia::InterfaceDefinition.reset
  end

  def test_object_definition_happy_path
    $var = "X"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o = Vidalia::Object.define(:name => "o", :parent => i) {$var = "O"} 
    assert o.is_a?(Vidalia::ObjectDefinition)
    assert o.object.is_a?(Vidalia::Object)
    assert i.interface.children.size == 1
    assert i.interface.children.first == o.object
    assert $var == "X"
  end

  def test_object_definition_parameter_checking
    assert_raises(RuntimeError) { 
      raise "hello"
    }
  end

end
