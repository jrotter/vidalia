require 'minitest/autorun'
require 'test_helper'

class ElementTest < Minitest::Test

  def test_new_element_happy_path
    assert Vidalia::Element.new(:name => "e",:logtext => "d").is_a?(Vidalia::Element)
  end

  def test_new_element_logtext
    # Logtext calculation with logtext specified, parent added post-initialization
    o = Vidalia::Object.new(:name => "object")
    e1 = Vidalia::Element.new(:name => "element",:logtext => "cat")
    assert e1.logtext == "cat"
    e1.add_to_object(o)
    assert e1.logtext == "cat"

    # Logtext calculation with logtext specified, parent added inline
    o = Vidalia::Object.new(:name => "object")
    e1 = Vidalia::Element.new(:name => "element",:logtext => "cat",:parent => o)
    assert e1.logtext == "cat"

    # Logtext calculation without logtext specified, parent added post-initialization
    o = Vidalia::Object.new(:name => "object")
    e1 = Vidalia::Element.new(:name => "element")
    assert e1.logtext == nil
    e1.add_to_object(o)
    assert e1.logtext == "object element"

    # Logtext calculation without logtext specified, parent added inline
    o = Vidalia::Object.new(:name => "object")
    e1 = Vidalia::Element.new(:name => "element",:parent => o)
    assert e1.logtext == "object element"
  end

  def test_new_element_validation_checks
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(:name => :not_a_string,:logtext => "d")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(:logtext => "d")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(:name => "c",:logtext => :not_a_string)
    }
  end

  def test_add_element_to_parent_via_self
    # Parent is a Object
    p = Vidalia::Object.new(:name => "object")
    c = Vidalia::Element.new(:name => "c",:logtext => "d")
    assert c.add_to_object(p).is_a?(Vidalia::Element)
    assert p.element("c") == c
  end

  def test_add_element_to_object_via_constructor
    # Parent is a Object
    p = Vidalia::Object.new(:name => "object")
    assert (c = Vidalia::Element.new(:name => "c",:logtext => "d",:parent => p)).is_a?(Vidalia::Element)
    assert p.element("c") == c
    assert (c = Vidalia::Element.new(:name => "c",:parent => p)).is_a?(Vidalia::Element)
    assert p.element("c") == c

    # Parent is an Interface (error expected)
    p = Vidalia::Interface.new(:name => "interface")
    assert_raises(RuntimeError) {
      c = Vidalia::Element.new(:name => "c",:logtext => "d",:parent => p)
    }
    assert_raises(RuntimeError) {
      c = Vidalia::Element.new(:name => "c",:parent => p)
    }

    # Parent is a Element (error expected)
    p = Vidalia::Element.new(:name => "element")
    assert_raises(RuntimeError) {
      c = Vidalia::Element.new(:name => "c",:logtext => "d",:parent => p)
    }
    assert_raises(RuntimeError) {
      c = Vidalia::Element.new(:name => "c",:parent => p)
    }

    # Parent is Gibberish (error expected)
    assert_raises(RuntimeError) {
      c = Vidalia::Element.new(:name => "c",:logtext => "d",:parent => "not an object")
    }
    assert_raises(RuntimeError) {
      c = Vidalia::Element.new(:name => "c",:parent => "not an object")
    }
  end

  def test_vidalia_generic_directives_input
    @val = nil
    c1 = Vidalia::Element.new(:name => "c1",:logtext => "element one")
    c1.add_set { |value| @val = value }
    c1.add_get { @val }
    c1.set "cat"
    assert c1.get == "cat"
    assert c1.retrieve == "cat"
    assert c1.confirm "cat"
    c1.verify "cat"
    assert_raises(RuntimeError) { c1.verify "tiger" }
    assert @val == "cat"

    c1.update "dog"
    assert c1.get == "dog"
    assert c1.retrieve == "dog"
    assert c1.confirm "dog"
    c1.verify "dog"
    assert_raises(RuntimeError) { c1.verify "dingo" }
    assert @val == "dog"
  end
 
  def test_vidalia_custom_directives_input
    @val = nil
    c1 = Vidalia::Element.new(:name => "c1",:logtext => "element one")
    c1.add_update { |value| "chicken" }
    c1.add_retrieve { "duck" }
    c1.add_verify { |value| "goose" }
    c1.add_confirm { |value| "moose" }
    c1.add_set { |value| @val = value }
    c1.add_get { @val }
    c1.set "cat"
    assert c1.get == "cat"
    assert c1.update("something") == "chicken"
    assert c1.update("anything") == "chicken"
    assert c1.retrieve == "duck"
    assert c1.verify("something") == "goose"
    assert c1.verify("anything") == "goose"
    assert c1.confirm("something") == "moose"
    assert c1.confirm("anything") == "moose"
    assert @val == "cat"
  end
 
end
