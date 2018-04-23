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

  def test_interface_definition_happy_path_dsl
    $var = "cat"
    a = interface 'm' do
      init { $var = 'dog' }
    end
    assert a.is_a?(Vidalia::Interface)
    assert $var == "cat"
  end

  def test_interface_definition_parameter_checking_dsl
    assert_raises(RuntimeError) do
      interface 2 do
        init { |var| var = 'dog' }
      end
    end
    assert_raises(ArgumentError) do
      interface do
        init { |var| var = 'dog' }
      end
    end
  end

  def test_interface_instantiation_no_block_dsl
    $var = "X"
    interface 'i'
    int = Vidalia::Interface.get("i")
    assert $var == "X"
  end

  def test_interface_child_creation_dsl
    $var = "a"

    interface 'i' do
      init { $var = 'I' }
      object 'o1' do
        init { $var = 'O1' }
      end
      object 'o2' do
        init { $var = 'O2' }
      end
      object 'o3' do
        init { $var = 'O3' }
      end
    end

    int = Vidalia::Interface.get("i")
    assert int.is_a?(Vidalia::Interface)
    assert $var == "I"
    assert int.name == "i"
    assert int.parent == nil
    assert int.number_of_children == 0

    obj1 = int.object("o1")
    assert obj1.is_a?(Vidalia::Object)
    assert $var == "O1"
    assert obj1.name == "o1"
    assert obj1.parent == int
    assert int.number_of_children == 1
    assert obj1.number_of_children == 0

    obj2 = int.object("o2")
    assert obj2.is_a?(Vidalia::Object)
    assert $var == "O2"
    assert obj2.name == "o2"
    assert obj2.parent == int
    assert int.number_of_children == 2
    assert obj2.number_of_children == 0

    obj3 = int.object("o3")
    assert obj3.is_a?(Vidalia::Object)
    assert $var == "O3"
    assert obj3.name == "o3"
    assert obj3.parent == int
    assert int.number_of_children == 3
    assert obj3.number_of_children == 0
  end

  def test_multiple_interface_definition_dsl
    interface 'i' do
      object 'o1' do
        init { $var = 'O1' }
      end
      object 'o2' do
        init { $var = 'O2' }
      end
    end

    int = Vidalia::Interface.get("i")
    obj1 = int.object("o1")
    assert obj1.is_a?(Vidalia::Object)
    assert obj1.name == "o1"

    obj2 = int.object("o2")
    assert obj2.is_a?(Vidalia::Object)
    assert obj2.name == "o2"
  end

end
