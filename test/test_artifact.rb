require 'minitest/autorun'
require 'test_helper'

class ArtifactTest < Minitest::Test

  def test_artifact_initialization_definition_happy_path
    # Minimal parameters
    $var = "X"
    a = Vidalia::Artifact.new(:name => "a") { $var = "A" } 
    assert a.is_a?(Vidalia::Artifact)
    assert $var == "X"
    assert a.name == "a"
    assert a.parent == nil
    assert a.number_of_children == 0

    # Parent Specified
    b = Vidalia::Artifact.new(:name => "b", :parent => a) { $var = "B" } 
    assert b.is_a?(Vidalia::Artifact)
    assert $var == "X"
    assert b.name == "b"
    assert b.parent == a
    assert b.number_of_children == 0
    assert a.number_of_children == 1
    assert a.get_child("b") == b

    # Next Child
    c = Vidalia::Artifact.new(:name => "c", :parent => a) { $var = "C" } 
    assert c.is_a?(Vidalia::Artifact)
    assert $var == "X"
    assert c.name == "c"
    assert c.parent == a
    assert c.number_of_children == 0
    assert a.number_of_children == 2
    assert a.get_child("b") == b
    assert a.get_child("c") == c

    # One More Child
    d = Vidalia::Artifact.new(:name => "d", :parent => a) { $var = "D" } 
    assert d.is_a?(Vidalia::Artifact)
    assert $var == "X"
    assert d.name == "d"
    assert d.parent == a
    assert d.number_of_children == 0
    assert a.number_of_children == 3
    assert a.get_child("b") == b
    assert a.get_child("c") == c
    assert a.get_child("d") == d
  end


  def test_artifact_initialization_instantiation_happy_path
    a = Vidalia::Artifact.new(:name => "a") { $var = "A" } 
    b = Vidalia::Artifact.new(:name => "b", :parent => a) { $var = "B" } 
    c = Vidalia::Artifact.new(:name => "c", :parent => a) { $var = "C" } 
    d = Vidalia::Artifact.new(:name => "d", :parent => a) { $var = "D" } 
    
    $var = "X"
    w = Vidalia::Artifact.new(:name => "w", :definition => a)
    assert w.is_a?(Vidalia::Artifact)
    assert $var == "A"
    assert w.name == "w"
    assert w.parent == nil
    assert w.number_of_children == 0

    x = Vidalia::Artifact.new(:name => "x", :parent => w, :definition => b)
    assert x.is_a?(Vidalia::Artifact)
    assert $var == "B"
    assert x.name == "x"
    assert x.parent == w
    assert x.number_of_children == 0
    assert w.number_of_children == 1
    assert w.get_child("x") == x

    y = Vidalia::Artifact.new(:name => "y", :parent => w, :definition => c)
    assert y.is_a?(Vidalia::Artifact)
    assert $var == "C"
    assert y.name == "y"
    assert y.parent == w
    assert y.number_of_children == 0
    assert w.number_of_children == 2
    assert w.get_child("x") == x
    assert w.get_child("y") == y

    z = Vidalia::Artifact.new(:name => "z", :parent => w, :definition => d)
    assert z.is_a?(Vidalia::Artifact)
    assert $var == "D"
    assert z.name == "z"
    assert z.parent == w
    assert z.number_of_children == 0
    assert w.number_of_children == 3
    assert w.get_child("x") == x
    assert w.get_child("y") == y
    assert w.get_child("z") == z
  end

  def test_artifact_initialization_parameter_checking
    p = Vidalia::Artifact.new(:name => "p") { $var = "parent" } 
    assert_raises(RuntimeError) {
      a = Vidalia::Artifact.new(:name => :a) { $var = "dog" } 
    }
    assert_raises(RuntimeError) {
      a = Vidalia::Artifact.new(:parent => p) { $var = "dog" } 
    }
    assert_raises(TypeError) {
      a = Vidalia::Artifact.new("parent") { $var = "dog" } 
    }
  end

end
