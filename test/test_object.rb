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
    assert i.interface.number_of_children == 1
    assert i.interface.get_child("o") == o.object
    assert $var == "X"
  end

  def test_object_definition_parameter_checking
    assert_raises(RuntimeError) { 
      raise "hello"
    }
  end

  def test_object_child_creation
    $var = "a"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o = Vidalia::Object.define(:name => "o", :parent => i) {$var = "O"} 
    e1 = Vidalia::Element.define(:name => "e1", :parent => o) {$var = "E1"} 
    e2 = Vidalia::Element.define(:name => "e2", :parent => o) {$var = "E2"} 
    e3 = Vidalia::Element.define(:name => "e3", :parent => o) {$var = "E3"} 

    int = Vidalia::Interface.get("i")
    assert int.is_a?(Vidalia::Interface)
    assert $var == "I"
    assert int.name == "i"
    assert int != i
    assert int.parent == nil
    assert int.number_of_children == 0

    obj = int.object("o")
    assert obj.is_a?(Vidalia::Object)
    assert $var == "O"
    assert obj.name == "o"
    assert obj != o
    assert obj.parent == int
    assert int.number_of_children == 1
    assert obj.number_of_children == 0

    ele1 = obj.element("e1")
    assert ele1.is_a?(Vidalia::Element)
    assert $var == "E1"
    assert ele1.name == "e1"
    assert ele1 != e1
    assert ele1.parent == obj
    assert int.number_of_children == 1
    assert obj.number_of_children == 1
    assert ele1.number_of_children == 0

    ele2 = obj.element("e2")
    assert ele2.is_a?(Vidalia::Element)
    assert $var == "E2"
    assert ele2.name == "e2"
    assert ele2 != e2
    assert ele2.parent == obj
    assert int.number_of_children == 1
    assert obj.number_of_children == 2
    assert ele2.number_of_children == 0

    ele3 = obj.element("e3")
    assert ele3.is_a?(Vidalia::Element)
    assert $var == "E3"
    assert ele3.name == "e3"
    assert ele3 != e3
    assert ele3.parent == obj
    assert int.number_of_children == 1
    assert obj.number_of_children == 3
    assert ele3.number_of_children == 0
  end

  def test_object_add_method
    $var = "a"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o1 = Vidalia::Object.define(:name => "o1", :parent => i) {$var = "O1"} 
    o1.add_method(:name => "dog") { $var = "dog" }
    o1.add_method(:name => "cat") { $var = "cat" }
    o2 = Vidalia::Object.define(:name => "o2", :parent => i) {$var = "O2"} 
    o2.add_method(:name => "bat") { $var = "bat" }
    int = Vidalia::Interface.get("i")
    obj1 = int.object("o1")
    obj2 = int.object("o2")
    assert $var == "O2"
    obj1.dog()
    assert $var == "dog"
    obj1.cat()
    assert $var == "cat"
    assert_raises(RuntimeError) { 
      obj1.bat()
    }
    assert $var == "cat"
    obj2.bat()
    assert $var == "bat"
    assert_raises(RuntimeError) { 
      obj2.cat()
    }
    assert_raises(RuntimeError) { 
      obj2.dog()
    }
    assert $var == "bat"
  end

end
