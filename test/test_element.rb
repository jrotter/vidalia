require 'minitest/autorun'
require 'test_helper'

class ElementTest < Minitest::Test

  def setup
    # Clean up the Interface Definitions
    Vidalia::InterfaceDefinition.reset
  end

  def test_element_definition_happy_path
    $var = "X"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o = Vidalia::Object.define(:name => "o", :parent => i) {$var = "O"} 
    e = Vidalia::Element.define(:name => "e", :parent => o) {$var = "E"} 
    assert e.is_a?(Vidalia::ElementDefinition)
    assert e.element.is_a?(Vidalia::Element)
    assert o.object.number_of_children == 1
    assert o.object.get_child("e") == e.element
    assert $var == "X"
  end

  def test_element_definition_parameter_checking
    assert_raises(RuntimeError) { 
      raise "hello"
    }
  end

end
