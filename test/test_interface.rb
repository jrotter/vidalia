require 'minitest/autorun'
require 'test_helper'

class InterfaceTest < Minitest::Test

  def test_interface_initialize
    my_interface = Vidalia::Interface.new(:name => "a")
    assert my_interface.is_a? Vidalia::Interface
  end

  def test_interface_initialize_no_name
    # No name
    assert_raises(RuntimeError) { 
      my_interface = Vidalia::Interface.new
    }
  end

  def test_interface_find
    assert Vidalia::Interface.find("Interface One") == nil
    assert Vidalia::Interface.find("Interface Two") == nil
    assert Vidalia::Interface.find("Interface Three") == nil

    int1 = Vidalia::Interface.new(:name => "Interface One")
    assert Vidalia::Interface.find("Interface One") == int1
    assert Vidalia::Interface.find("Interface Two") == nil
    assert Vidalia::Interface.find("Interface Three") == nil

    int2 = Vidalia::Interface.new(:name => "Interface Two")
    assert Vidalia::Interface.find("Interface One") == int1
    assert Vidalia::Interface.find("Interface Two") == int2
    assert Vidalia::Interface.find("Interface Three") == nil

    int3 = Vidalia::Interface.new(:name => "Interface Three")
    assert Vidalia::Interface.find("Interface One") == int1
    assert Vidalia::Interface.find("Interface Two") == int2
    assert Vidalia::Interface.find("Interface Three") == int3
  end

  def test_add_object_to_interface_happy_path
    i = Vidalia::Interface.new(:name => "interface")
    o = Vidalia::Object.new(:name => "my object")
    i.add_object(o)
    assert i.object("my object").is_a?(Vidalia::Object)
    assert i.object("my object").name == "my object"
  end

  def test_add_object_to_interface_bad_object
    i = Vidalia::Interface.new(:name => "my interface")
    o = Vidalia::Object.new(:name => "my object")
    i.add_object(o)
    assert_raises(RuntimeError) { 
      i.object("will not be found")
    }
  end

  def test_add_wrong_structure_to_interface
    i = Vidalia::Interface.new(:name => "i")
    i2 = Vidalia::Interface.new(:name => "i2")
    o = Vidalia::Object.new(:name => "o")
    e = Vidalia::Element.new(:name => "e",:logtext => "l")
    assert i.add_object(o).is_a?(Vidalia::Interface)
    assert_raises(RuntimeError) { i.add_object(i2) }
    assert_raises(RuntimeError) { i.add_object(e) }
  end

end
