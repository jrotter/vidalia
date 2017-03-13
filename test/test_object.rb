require 'minitest/autorun'
require 'test_helper'

class ObjectTest < Minitest::Test

  def test_interface_definition_happy_path
    Vidalia::Object.define(:name => "n") {$var = "dog"} 
    assert Vidalia::Object.get_definition_data("n",Vidalia::Object)[:name] == "n"
    assert Vidalia::Object.get_definition_data("n",Vidalia::Object)[:initialization_block].is_a?(Proc)
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
    Vidalia::Object.define(:name => "n") {$var = "dog"} 
    $var = "cat"
    a = Vidalia::Object.new("n")
    assert $var == "dog"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Object)

    Vidalia::Object.define(:name => "n") {$var = "N"} 
    Vidalia::Object.define(:name => "o") {$var = "O"} 
    Vidalia::Object.define(:name => "p") {$var = "P"} 
    $var = "X"
    a = Vidalia::Object.new("n")
    assert $var == "N"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Object)
    a = Vidalia::Object.new("o")
    assert $var == "O"
    assert a.name == "o"
    assert a.is_a?(Vidalia::Object)
    a = Vidalia::Object.new("p")
    assert $var == "P"
    assert a.name == "p"
    assert a.is_a?(Vidalia::Object)
  end

  def test_interface_creation_error_checking
    Vidalia::Object.define(:name => "n") {$var = "dog"} 
    assert_raises(RuntimeError) { 
      Vidalia::Object.new("Undefined Name")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Object.new(:name => "n")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Object.new(:n)
    }
    assert_raises(RuntimeError) { 
      Vidalia::Object.new(["not","a","string"])
    }
  end

  def test_add_and_get_element
    Vidalia::Object.define(:name => "par") {$var = "p"} 
    Vidalia::Element.define(:name => "c1", :interface_name => "par") {$var = "1"} 
    Vidalia::Element.define(:name => "c2", :interface_name => "par") {$var = "2"} 
    Vidalia::Element.define(:name => "c3", :interface_name => "par") {$var = "3"} 
    p = Vidalia::Object.new("par")
    c1 = Vidalia::Element.new("c1")
    c2 = Vidalia::Element.new("c2")
    c3 = Vidalia::Element.new("c3")
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
    p = Vidalia::Object.new("par")
    c = Vidalia::Element.new("chi")
    o = Vidalia::Object.new("other")
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
    Vidalia::Object.define(:name => "par") {$var = "p"} 
    Vidalia::Element.define(:name => "chi",:interface_name => "par") {$var = "c"} 
    p = Vidalia::Object.new("par")
    c = Vidalia::Element.new("chi")
    assert p.add_element(c) == c
    assert_raises(RuntimeError) { 
      p.element(:chi)
    }
    assert_raises(RuntimeError) { 
      p.element(c)
    }
  end

  def test_add_object_parent
    Vidalia::Interface.define(:name => "parent") {$var = "p"}
    Vidalia::Object.define(:name => "child") {$var = "c"}
    p = Vidalia::Interface.new("parent")
    c = Vidalia::Object.new("child")
    assert c.set_parent(p) == p
    assert c.parent == p
  end

  def test_add_object_parent_validity_checking
    Vidalia::Object.define(:name => "child") {$var = "c"}
    Vidalia::Object.define(:name => "dog") {$var = "d"}
    c = Vidalia::Object.new("child")
    d = Vidalia::Object.new("dog")
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
