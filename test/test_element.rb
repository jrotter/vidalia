require 'minitest/autorun'
require 'test_helper'

class ElementTest < Minitest::Test

  def test_object_definition_happy_path
    a = Vidalia::Element.define(:name => "n") {$var = "dog"} 
    assert a.is_a?(Vidalia::Identifier)
    assert Vidalia::Element.get_definition_data("n",nil)[:name] == "n"
    assert Vidalia::Element.get_definition_data("n",nil)[:initialization_block].is_a?(Proc)
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
    n = Vidalia::Element.define(:name => "n") {$var = "dog"} 
    $var = "cat"
    a = Vidalia::Element.new(:name => "n")
    assert $var == "dog"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Element)
    assert a.id == n

    n = Vidalia::Element.define(:name => "n") {$var = "N"} 
    o = Vidalia::Element.define(:name => "o") {$var = "O"} 
    p = Vidalia::Element.define(:name => "p") {$var = "P"} 
    $var = "X"
    a = Vidalia::Element.new(:name => "n")
    assert $var == "N"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Element)
    assert a.id == n
    a = Vidalia::Element.new(:name => "o")
    assert $var == "O"
    assert a.name == "o"
    assert a.is_a?(Vidalia::Element)
    assert a.id == o
    a = Vidalia::Element.new(:name => "p")
    assert $var == "P"
    assert a.name == "p"
    assert a.is_a?(Vidalia::Element)
    assert a.id == p
  end

  def test_object_creation_error_checking
    Vidalia::Element.define(:name => "n") {$var = "dog"} 
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(:name => "Undefined Name")
    }
    assert_raises(TypeError) { 
      Vidalia::Element.new("n")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(:name => :n)
    }
    assert_raises(RuntimeError) { 
      Vidalia::Element.new(:name => ["not","a","string"])
    }
  end

  def test_add_element_parent
    p_id = Vidalia::Object.define(:name => "parent") {$var = "p"}
    c_id = Vidalia::Element.define(:name => "child") {$var = "c"}
    p = Vidalia::Object.new(:name => "parent")
    c = Vidalia::Element.new(:name => "child")
    assert c.set_parent(p) == p
    assert c.parent == p
  end

  def test_add_element_parent_validity_checking
    Vidalia::Element.define(:name => "child") {$var = "c"}
    Vidalia::Element.define(:name => "dog") {$var = "d"}
    c = Vidalia::Element.new(:name => "child")
    d = Vidalia::Element.new(:name => "dog")
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
