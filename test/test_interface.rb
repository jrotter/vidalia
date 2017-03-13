require 'minitest/autorun'
require 'test_helper'

class InterfaceTest < Minitest::Test

  def test_interface_definition_happy_path
    Vidalia::Interface.define(:name => "n") {$var = "dog"} 
    assert Vidalia::Interface.get_definition_data("n",Vidalia::Interface)[:name] == "n"
    assert Vidalia::Interface.get_definition_data("n",Vidalia::Interface)[:initialization_block].is_a?(Proc)
  end

  def test_interface_definition_parameter_checking
    assert_raises(RuntimeError) { 
      Vidalia::Interface.define(:name => 2) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Interface.define() {|var| var = "dog"}
    }
  end

  def test_interface_definition_and_creation_happy_path
    Vidalia::Interface.define(:name => "n") {$var = "dog"} 
    $var = "cat"
    a = Vidalia::Interface.new("n")
    assert $var == "dog"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Interface)

    Vidalia::Interface.define(:name => "n") {$var = "N"} 
    Vidalia::Interface.define(:name => "o") {$var = "O"} 
    Vidalia::Interface.define(:name => "p") {$var = "P"} 
    $var = "X"
    a = Vidalia::Interface.new("n")
    assert $var == "N"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Interface)
    a = Vidalia::Interface.new("o")
    assert $var == "O"
    assert a.name == "o"
    assert a.is_a?(Vidalia::Interface)
    a = Vidalia::Interface.new("p")
    assert $var == "P"
    assert a.name == "p"
    assert a.is_a?(Vidalia::Interface)
  end

  def test_interface_creation_error_checking
    Vidalia::Interface.define(:name => "n") {$var = "dog"} 
    assert_raises(RuntimeError) { 
      Vidalia::Interface.new("Undefined Name")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Interface.new(:name => "n")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Interface.new(:n)
    }
    assert_raises(RuntimeError) { 
      Vidalia::Interface.new(["not","a","string"])
    }
  end

  def test_add_and_get_object
    Vidalia::Interface.define(:name => "par") {$var = "p"} 
    Vidalia::Object.define(:name => "c1", :interface_name => "par") {$var = "1"} 
    Vidalia::Object.define(:name => "c2", :interface_name => "par") {$var = "2"} 
    Vidalia::Object.define(:name => "c3", :interface_name => "par") {$var = "3"} 
    p = Vidalia::Interface.new("par")
    c1 = Vidalia::Object.new("c1")
    c2 = Vidalia::Object.new("c2")
    c3 = Vidalia::Object.new("c3")
    assert p.add_object(c1) == c1
    assert p.object("c1") == c1
    assert p.object("none") == nil
    assert p.add_object(c2) == c2
    assert p.object("c1") == c1
    assert p.object("c2") == c2
    assert p.object("none") == nil
    assert p.add_object(c3) == c3
    assert p.object("c1") == c1
    assert p.object("c2") == c2
    assert p.object("c3") == c3
    assert p.object("none") == nil
  end

  def test_add_object_validity_checking
    Vidalia::Interface.define(:name => "par") {$var = "p"} 
    Vidalia::Interface.define(:name => "other") {$var = "p"} 
    Vidalia::Object.define(:name => "chi",:interface_name => "par") {$var = "c"} 
    p = Vidalia::Interface.new("par")
    c = Vidalia::Object.new("chi")
    o = Vidalia::Interface.new("other")
    assert_raises(RuntimeError) { 
      p.add_object(2)
    }
    assert_raises(RuntimeError) { 
      p.add_object("child")
    }
    assert_raises(RuntimeError) { 
      p.add_object(o)
    }
  end

  def test_object_validity_checking
    Vidalia::Interface.define(:name => "par") {$var = "p"} 
    Vidalia::Object.define(:name => "chi",:interface_name => "par") {$var = "c"} 
    p = Vidalia::Interface.new("par")
    c = Vidalia::Object.new("chi")
    assert p.add_object(c) == c
    assert_raises(RuntimeError) { 
      p.object(:chi)
    }
    assert_raises(RuntimeError) { 
      p.object(c)
    }
  end

end
