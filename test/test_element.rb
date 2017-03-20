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

  def test_element_get
    $var = "X"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o = Vidalia::Object.define(:name => "o", :parent => i) {$var = "O"} 
    e = Vidalia::Element.define(:name => "e", :parent => o) {$var = "E"} 
    e.add_get { |inhash| $var }

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele = obj.element("e")
    $var = "X"
    assert ele.get() == "X"
  end

  def test_element_set
    $var = "X"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o = Vidalia::Object.define(:name => "o", :parent => i) {$var = "O"} 
    e = Vidalia::Element.define(:name => "e", :parent => o) {$var = "E"} 
    e.add_set { |inhash| $var = inhash[:value] }

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele = obj.element("e")
    $var = "X"
    ele.set(:value => "test")
    assert $var == "test"
  end

end
