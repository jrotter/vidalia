require 'minitest/autorun'
require 'test_helper'

class ElementTest < Minitest::Test

  def test_object_definition_happy_path
    Vidalia::Element.define(:name => "n") {$var = "dog"} 
    assert Vidalia::Element.get_definition_data("n",Vidalia::Element)[:name] == "n"
    assert Vidalia::Element.get_definition_data("n",Vidalia::Element)[:initialization_block].is_a?(Proc)
  end

  def test_object_definition_parameter_checking
    assert_raises(RuntimeError) { 
      Vidalia::Element.define(:name => 2) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Element.define() {|var| var = "dog"}
    }
  end

  def test_object_definition_and_creation_happy_path
    Vidalia::Element.define(:name => "n") {$var = "dog"} 
    $var = "cat"
    a = Vidalia::Element.new("n")
    assert $var == "dog"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Element)

    Vidalia::Element.define(:name => "n") {$var = "N"} 
    Vidalia::Element.define(:name => "o") {$var = "O"} 
    Vidalia::Element.define(:name => "p") {$var = "P"} 
    $var = "X"
    a = Vidalia::Element.new("n")
    assert $var == "N"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Element)
    a = Vidalia::Element.new("o")
    assert $var == "O"
    assert a.name == "o"
    assert a.is_a?(Vidalia::Element)
    a = Vidalia::Element.new("p")
    assert $var == "P"
    assert a.name == "p"
    assert a.is_a?(Vidalia::Element)
  end

  def test_object_creation_error_checking
    Vidalia::Element.define(:name => "n") {$var = "dog"} 
    assert_raises(RuntimeError) { 
      Vidalia::Element.new("Undefined Name")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(:name => "n")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(:n)
    }
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(["not","a","string"])
    }
  end

  def test_add_element_parent
    Vidalia::Object.define(:name => "parent") {$var = "p"}
    Vidalia::Element.define(:name => "child") {$var = "c"}
    p = Vidalia::Object.new("parent")
    c = Vidalia::Element.new("child")
    assert c.set_parent(p) == p
    assert c.parent == p
  end

  def test_add_element_parent_validity_checking
    Vidalia::Element.define(:name => "child") {$var = "c"}
    Vidalia::Element.define(:name => "dog") {$var = "d"}
    c = Vidalia::Element.new("child")
    d = Vidalia::Element.new("dog")
    assert_raises(RuntimeError) {
      c.set_parent(nil)
    }
    assert_raises(RuntimeError) {
      c.set_parent("child")
    }
    assert_raises(RuntimeError) {
      c.set_parent(d)
    }
  end

end
