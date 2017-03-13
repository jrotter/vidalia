require 'minitest/autorun'
require 'test_helper'

class ObjectTest < Minitest::Test

  def test_interface_definition_happy_path
    a = Vidalia::Object.define(:name => "n") {$var = "dog"} 
    assert a.is_a?(Vidalia::Identifier)
    assert Vidalia::Object.get_definition_data("n",nil)[:name] == "n"
    assert Vidalia::Object.get_definition_data("n",nil)[:initialization_block].is_a?(Proc)
  end

  def test_interface_definition_parameter_checking
    assert_raises(RuntimeError) { 
      Vidalia::Object.define(:name => 2) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Object.define() {|var| var = "dog"}
    }
  end

  def test_interface_definition_and_creation_happy_path
    n = Vidalia::Object.define(:name => "n") {$var = "dog"} 
    $var = "cat"
    a = Vidalia::Object.new(:name => "n")
    assert $var == "dog"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Object)
    assert a.id == n

    n = Vidalia::Object.define(:name => "n") {$var = "N"} 
    o = Vidalia::Object.define(:name => "o") {$var = "O"} 
    p = Vidalia::Object.define(:name => "p") {$var = "P"} 
    $var = "X"
    a = Vidalia::Object.new(:name => "n")
    assert $var == "N"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Object)
    assert a.id == n
    a = Vidalia::Object.new(:name => "o")
    assert $var == "O"
    assert a.name == "o"
    assert a.is_a?(Vidalia::Object)
    assert a.id == o
    a = Vidalia::Object.new(:name => "p")
    assert $var == "P"
    assert a.name == "p"
    assert a.is_a?(Vidalia::Object)
    assert a.id == p
  end

  def test_interface_creation_error_checking
    Vidalia::Object.define(:name => "n") {$var = "dog"} 
    assert_raises(RuntimeError) { 
      Vidalia::Object.new(:name => "Undefined Name")
    }
    assert_raises(TypeError) { 
      Vidalia::Object.new("n")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Object.new(:name => :n)
    }
    assert_raises(RuntimeError) { 
      Vidalia::Object.new(:name => ["not","a","string"])
    }
  end

  def test_add_and_get_element
    p_id = Vidalia::Object.define(:name => "par") {$var = "p"} 
    c1_id = Vidalia::Element.define(:name => "c1", :interface_name => "par") {$var = "1"} 
    c2_id = Vidalia::Element.define(:name => "c2", :interface_name => "par") {$var = "2"} 
    c3_id = Vidalia::Element.define(:name => "c3", :interface_name => "par") {$var = "3"} 
    p = Vidalia::Object.new(:name => "par")
    c1 = Vidalia::Element.new(:name => "c1")
    c2 = Vidalia::Element.new(:name => "c2")
    c3 = Vidalia::Element.new(:name => "c3")
    assert p.add_element(c1) == c1
    assert p.element("c1") == c1
    assert p.element("none") == nil
    assert p.add_element(c2) == c2
    assert p.element("c1") == c1
    assert p.element("c2") == c2
    assert p.element("none") == nil
    assert p.add_element(c3) == c3
    assert p.element("c1") == c1
    assert p.element("c2") == c2
    assert p.element("c3") == c3
    assert p.element("none") == nil
  end

  def test_add_element_validity_checking
    Vidalia::Object.define(:name => "par") {$var = "p"} 
    Vidalia::Object.define(:name => "other") {$var = "p"} 
    Vidalia::Element.define(:name => "chi",:interface_name => "par") {$var = "c"} 
    p = Vidalia::Object.new(:name => "par")
    c = Vidalia::Element.new(:name => "chi")
    o = Vidalia::Object.new(:name => "other")
    assert_raises(RuntimeError) { 
      p.add_element(2)
    }
    assert_raises(RuntimeError) { 
      p.add_element("child")
    }
    assert_raises(RuntimeError) { 
      p.add_element(o)
    }
  end

  def test_element_validity_checking
    p_id = Vidalia::Object.define(:name => "par") {$var = "p"} 
    c_id = Vidalia::Element.define(:name => "chi",:parent => p_id) {$var = "c"} 
    p = Vidalia::Object.new(:name => "par")
    c = Vidalia::Element.new(:name => "chi", :parent => p_id)
    assert p.add_element(c) == c
    assert_raises(RuntimeError) { 
      p.element(:chi)
    }
    assert_raises(RuntimeError) { 
      p.element(c)
    }
  end

  def test_add_object_parent
    p_id = Vidalia::Interface.define(:name => "parent") {$var = "p"}
    c_id = Vidalia::Object.define(:name => "child", :parent => p_id) {$var = "c"}
    p = Vidalia::Interface.new(:name => "parent")
    c = Vidalia::Object.new(:name => "child", :parent => p_id)
    assert c.set_parent(p) == p
    assert c.parent == p
  end

  def test_add_object_parent_validity_checking
    c_id = Vidalia::Object.define(:name => "child") {$var = "c"}
    d_id = Vidalia::Object.define(:name => "dog") {$var = "d"}
    c = Vidalia::Object.new(:name => "child")
    d = Vidalia::Object.new(:name => "dog")
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
