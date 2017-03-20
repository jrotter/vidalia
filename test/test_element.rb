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

  def test_element_get_happy_path
    $var = "X"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o = Vidalia::Object.define(:name => "o", :parent => i) {$var = "O"} 
    e1 = Vidalia::Element.define(:name => "e1", :parent => o) {$var = "E1"} 
    e1.add_get { |instring| instring }
    e2 = Vidalia::Element.define(:name => "e2", :parent => o) {$var = "E2"} 
    e2.add_get { |inhash| inhash[:b] }
    e3 = Vidalia::Element.define(:name => "e3", :parent => o) {$var = "E3"} 
    e3.add_get { |do_not_care| "zebra" }
    e4 = Vidalia::Element.define(:name => "e4", :parent => o) {$var = "E4"} 
    e4.add_get { "Egypt" }
    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele2 = obj.element("e2")
    ele3 = obj.element("e3")
    ele4 = obj.element("e4")
    assert ele1.get("hi") == "hi"
    assert ele2.get({:a => "A",:b => "B",:c => "C"}) == "B"
    assert ele3.get() == "zebra"
    assert ele4.get() == "Egypt"
  end
    
  def test_element_get_parameter_checking
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o = Vidalia::Object.define(:name => "o", :parent => i) {$var = "O"} 
    e1 = Vidalia::Element.define(:name => "e1", :parent => o) {$var = "E1"} 
    assert_raises(RuntimeError) do
      e1.add_get { |string1,string2,string3| "#{string1}#{string2}#{string3}" }
    end
  end

  def test_element_set
    $var = "X"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o = Vidalia::Object.define(:name => "o", :parent => i) {$var = "O"} 
    e1 = Vidalia::Element.define(:name => "e1", :parent => o) { } 
    e1.add_set { |instring| $var = instring }
    e2 = Vidalia::Element.define(:name => "e2", :parent => o) { } 
    e2.add_set { |inhash| $var = inhash[:b] }
    e3 = Vidalia::Element.define(:name => "e3", :parent => o) { } 
    e3.add_set { |do_not_care| $var = "zebra" }
    e4 = Vidalia::Element.define(:name => "e4", :parent => o) { } 
    e4.add_set { $var = "Egypt" }

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele2 = obj.element("e2")
    ele3 = obj.element("e3")
    ele4 = obj.element("e4")
    $var = "X"
    ele1.set("hi")
    assert $var == "hi"
    ele2.set({:a => "A",:b => "B",:c => "C"})
    assert $var == "B"
    ele3.set()
    assert $var == "zebra"
    ele4.set()
    assert $var == "Egypt"
  end

end
