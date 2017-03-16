require 'minitest/autorun'
require 'test_helper'

class ArtifactTest < Minitest::Test

  def test_artifact_initialization_happy_path
    # Minimal parameters
    $var = "X"
    a = Vidalia::Artifact.new(:name => "a") { $var = "A" } 
    assert a.is_a?(Vidalia::Artifact)
    assert $var == "A"
    assert a.name == "a"
    assert a.parent == nil
    assert a.children == []

    # Parent Specified
    b = Vidalia::Artifact.new(:name => "b", :parent => a) { $var = "B" } 
    assert b.is_a?(Vidalia::Artifact)
    assert $var == "B"
    assert b.name == "b"
    assert b.parent == a
    assert b.children == []
    assert a.children.size == 1
    assert a.children.first == b

    # Next Child
    c = Vidalia::Artifact.new(:name => "c", :parent => a) { $var = "C" } 
    assert c.is_a?(Vidalia::Artifact)
    assert $var == "C"
    assert c.name == "c"
    assert c.parent == a
    assert c.children == []
    assert a.children.size == 2
    assert a.children.first == b
    assert a.children.last == c
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
