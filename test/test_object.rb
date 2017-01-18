require 'minitest/autorun'
require 'test_helper'

class ObjectTest < Minitest::Test

  def test_object_creation_happy_path
    assert Vidalia::Object.new(:name => "a").is_a?(Vidalia::Object)
  end

  def test_object_creation_object_name_definition
    assert_raises(RuntimeError) { 
      Vidalia::Object.new(:name => :not_a_string)
    }
    assert_raises(RuntimeError) { 
      Vidalia::Object.new(:name => ["not","a","string"])
    }
  end

  def test_add_object_to_interface_via_object_object
    o = Vidalia::Object.new(:name => "my object")
    o.add_to_interface("Hello")
    assert_raises(RuntimeError) { o.add_to_interface(nil) }
    assert_raises(RuntimeError) { o.add_to_interface(12) }
    i = Vidalia::Interface.find("Hello")
    assert i.object("my object") == o

    j = Vidalia::Interface.new(:name => "Goodbye")
    p = Vidalia::Object.new(:name => "my object")
    p.add_to_interface(j)
    assert_raises(RuntimeError) { p.add_to_interface(nil) }
    assert_raises(RuntimeError) { p.add_to_interface(12) }
    assert j.object("my object") == p
  end

  def test_add_element_to_object
    o = Vidalia::Object.new(:name => "object")
    e = Vidalia::Element.new(:name => "e",:logtext => "l")
    assert o.add_element(e).is_a?(Vidalia::Object)
  end

  def test_get_element_from_object
    o = Vidalia::Object.new(:name => "object")
    e1 = Vidalia::Element.new(:name => "e1",:logtext => "element one")
    e2 = Vidalia::Element.new(:name => "e2",:logtext => "element two")
    assert o.add_element(e1).add_element(e2).is_a?(Vidalia::Object)
    assert o.element("e1") == e1
    assert o.element("e2") == e2
    assert_raises(RuntimeError) { o.element("e3") }
  end

  def test_add_wrong_structure_to_object
    i = Vidalia::Interface.new(:name => "i")
    o = Vidalia::Object.new(:name => "o")
    o2 = Vidalia::Object.new(:name => "o2")
    e = Vidalia::Element.new(:name => "c")
    assert o.add_element(e).is_a?(Vidalia::Object)
    assert_raises(RuntimeError) { o.add_element(i) }
    assert_raises(RuntimeError) { o.add_element(o2) }
  end

end
