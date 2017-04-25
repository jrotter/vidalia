require 'minitest/autorun'
require 'test_helper'

class InterfaceTest < Minitest::Test

  def setup
    # Clean up the Interface Definitions
    Vidalia::InterfaceDefinition.reset
    Vidalia::set_logroutine { |logstring|
      logstring #No need to print anything out here
    }
  end

  def test_interface_definition_happy_path
    $var = "cat"
    a = Vidalia::Interface.define(:name => "m") {$var = "dog"} 
    assert a.is_a?(Vidalia::InterfaceDefinition)
    assert a.interface.is_a?(Vidalia::Interface)
    assert $var == "cat"
  end

  def test_interface_definition_parameter_checking
    assert_raises(RuntimeError) { 
      Vidalia::Interface.define(:name => 2) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Interface.define() {|var| var = "dog"}
    }
  end

  def test_interface_instantiation_no_block
    $var = "X"
    i = Vidalia::Interface.define(:name => "i")
    int = Vidalia::Interface.get("i")
    assert $var == "X"
  end

  def test_interface_child_creation
    $var = "a"
    i = Vidalia::Interface.define(:name => "i") {$var = "I"} 
    o1 = Vidalia::Object.define(:name => "o1", :parent => i) {$var = "O1"} 
    o2 = Vidalia::Object.define(:name => "o2", :parent => i) {$var = "O2"} 
    o3 = Vidalia::Object.define(:name => "o3", :parent => i) {$var = "O3"} 

    int = Vidalia::Interface.get("i")
    assert int.is_a?(Vidalia::Interface)
    assert $var == "I"
    assert int.name == "i"
    assert int != i
    assert int.parent == nil
    assert int.number_of_children == 0

    obj1 = int.object("o1")
    assert obj1.is_a?(Vidalia::Object)
    assert $var == "O1"
    assert obj1.name == "o1"
    assert obj1 != o1
    assert obj1.parent == int
    assert int.number_of_children == 1
    assert obj1.number_of_children == 0

    obj2 = int.object("o2")
    assert obj2.is_a?(Vidalia::Object)
    assert $var == "O2"
    assert obj2.name == "o2"
    assert obj2 != o2
    assert obj2.parent == int
    assert int.number_of_children == 2
    assert obj2.number_of_children == 0

    obj3 = int.object("o3")
    assert obj3.is_a?(Vidalia::Object)
    assert $var == "O3"
    assert obj3.name == "o3"
    assert obj3 != o3
    assert obj3.parent == int
    assert int.number_of_children == 3
    assert obj3.number_of_children == 0
  end

  def test_multiple_interface_definition
    a = Vidalia::Interface.define(:name => "i")
    o1 = Vidalia::Object.define(:name => "o1", :parent => a) {$var = "O1"} 
    b = Vidalia::Interface.define(:name => "i")
    o2 = Vidalia::Object.define(:name => "o2", :parent => b) {$var = "O2"} 
    int = Vidalia::Interface.get("i")

    obj1 = int.object("o1")
    assert obj1.is_a?(Vidalia::Object)
    assert obj1.name == "o1"

    obj2 = int.object("o2")
    assert obj2.is_a?(Vidalia::Object)
    assert obj2.name == "o2"
  end

end
