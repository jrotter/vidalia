require 'minitest/autorun'
require 'test_helper'

class ObjectTest < Minitest::Test

  def setup
    # Clean up the Interface Definitions
    Vidalia::InterfaceDefinition.reset
    Vidalia::set_logroutine { |logstring|
      logstring #No need to print anything out here
    }
  end

  def test_object_definition_happy_path_dsl
    $var = "X"

    o = nil
    i = interface 'i' do
      init { $var = 'I' }
      o = object 'o' do
        init { $var = 'O' }
      end
    end
    assert o.is_a?(Vidalia::Object)
    assert i.number_of_children == 1
    assert i.get_child("o") == o
    assert $var == "X"
  end

  def test_object_instantiation_no_block_dsl
    $var = "X"
    interface 'i' do
      init { $var = 'I' }
      object 'o'
    end
    int = Vidalia::Interface.get("i")
    assert $var == "I"
    obj = int.object("o")
    assert $var == "I"
  end

  def test_object_child_creation_dsl
    $var = "a"

    interface 'i' do
      init { $var = "I" }
      object 'o' do
        init { $var = 'O' }
        element 'e1' do
          init { $var = 'E1' }
        end
        element 'e2' do
          init { $var = 'E2' }
        end
        element 'e3' do
          init { $var = 'E3' }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    assert int.is_a?(Vidalia::Interface)
    assert $var == "I"
    assert int.name == "i"
    assert int.parent == nil
    assert int.number_of_children == 0

    obj = int.object("o")
    assert obj.is_a?(Vidalia::Object)
    assert $var == "O"
    assert obj.name == "o"
    assert obj.parent == int
    assert int.number_of_children == 1
    assert obj.number_of_children == 0


    ele1 = obj.element("e1")
    assert ele1.is_a?(Vidalia::Element)
    assert $var == "E1"
    assert ele1.name == "e1"
    assert ele1.parent == obj
    assert int.number_of_children == 1
    assert obj.number_of_children == 1
    assert ele1.number_of_children == 0

    ele2 = obj.element("e2")
    assert ele2.is_a?(Vidalia::Element)
    assert $var == "E2"
    assert ele2.name == "e2"
    assert ele2.parent == obj
    assert int.number_of_children == 1
    assert obj.number_of_children == 2
    assert ele2.number_of_children == 0

    ele3 = obj.element("e3")
    assert ele3.is_a?(Vidalia::Element)
    assert $var == "E3"
    assert ele3.name == "e3"
    assert ele3.parent == obj
    assert int.number_of_children == 1
    assert obj.number_of_children == 3
    assert ele3.number_of_children == 0
  end

  def test_object_add_method_dsl
    $var = "a"

    interface 'i' do
      init { $var = 'I' }

      object 'o1' do
        init { $var = 'O1' }
        dog { $var = 'dog' }
        cat { $var = 'cat' }
      end

      object 'o2' do
        init { $var = 'O2' }
        bat { $var = 'bat' }
      end
    end

    int = Vidalia::Interface.get("i")
    obj1 = int.object("o1")
    obj2 = int.object("o2")
    assert $var == "O2"
    obj1.dog
    assert $var == "dog"
    obj1.cat
    assert $var == "cat"
    assert_raises(RuntimeError) { obj1.bat }
    assert $var == "cat"
    obj2.bat
    assert $var == "bat"
    assert_raises(RuntimeError) { obj2.cat }
    assert_raises(RuntimeError) { obj2.dog }
    assert $var == "bat"
  end

end
