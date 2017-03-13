require 'minitest/autorun'
require 'test_helper'

class ArtifactTest < Minitest::Test

  def test_artifact_definition_happy_path
    # No extra parameters
    p_id = Vidalia::Identifier.new
    a = Vidalia::Artifact.define(:name => "a", :type => Vidalia::Artifact, :parent => p_id) { $var = "dog" } 
    assert a.is_a?(Vidalia::Identifier)
    assert Vidalia::Artifact.get_definition_data("a",p_id)[:name] == "a"
    assert Vidalia::Artifact.get_definition_data("a",p_id)[:type] == Vidalia::Artifact
    assert Vidalia::Artifact.get_definition_data("a",p_id)[:parent] == p_id
    assert Vidalia::Artifact.get_definition_data("a",p_id)[:initialization_block].is_a?(Proc)

    # Extra parameters
    q_id = Vidalia::Identifier.new
    b = Vidalia::Artifact.define(:name => "b",:type => Vidalia::Artifact, :parent => q_id, :otherstuff => "hello") {$var = "bird"} 
    assert a.is_a?(Vidalia::Identifier)
    assert b > a
    assert Vidalia::Artifact.get_definition_data("b",q_id)[:name] == "b"
    assert Vidalia::Artifact.get_definition_data("b",q_id)[:type] == Vidalia::Artifact
    assert Vidalia::Artifact.get_definition_data("b",q_id)[:parent] == q_id
    assert Vidalia::Artifact.get_definition_data("b",q_id)[:otherstuff] == "hello"
    assert Vidalia::Artifact.get_definition_data("b",q_id)[:initialization_block].is_a?(Proc)
    assert Vidalia::Artifact.get_definition_data("a",p_id)[:name] == "a"
    assert Vidalia::Artifact.get_definition_data("a",p_id)[:type] == Vidalia::Artifact
    assert Vidalia::Artifact.get_definition_data("a",p_id)[:parent] == p_id
    assert Vidalia::Artifact.get_definition_data("a",p_id)[:initialization_block].is_a?(Proc)
  end

  def test_artifact_definition_parameter_checking
    p_id = Vidalia::Identifier.new
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define(:type => Vidalia::Artifact, :parent => p_id) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define(:name => "n", :parent => 123) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define() {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define(:name => 2,:type => Vidalia::Artifact) {|var| var = "dog"}
    }
  end

  def test_artifact_definition_and_creation_happy_path
    n = Vidalia::Artifact.define(:name => "n",:type => Vidalia::Artifact) {$var = "dog"} 
    $var = "cat"
    a = Vidalia::Artifact.new(:name => "n")
    assert $var == "dog"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Artifact)
    assert a.id == n

    n = Vidalia::Artifact.define(:name => "n",:type => Vidalia::Artifact,:otherstuff => "hello") {$var = "N"} 
    o = Vidalia::Artifact.define(:name => "o",:type => Vidalia::Artifact,:foo => "bar") {$var = "O"} 
    p = Vidalia::Artifact.define(:name => "p",:type => Vidalia::Artifact,:monkey => "pants") {$var = "P"} 
    $var = "X"
    a = Vidalia::Artifact.new(:name => "n")
    assert $var == "N"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Artifact)
    assert a.id == n
    a = Vidalia::Artifact.new(:name => "o")
    assert $var == "O"
    assert a.name == "o"
    assert a.is_a?(Vidalia::Artifact)
    assert a.id == o
    a = Vidalia::Artifact.new(:name => "p")
    assert $var == "P"
    assert a.name == "p"
    assert a.is_a?(Vidalia::Artifact)
    assert a.id == p
  end

  def test_artifact_creation_error_checking
    Vidalia::Artifact.define(:name => "n",:type => Vidalia::Artifact) {$var = "dog"} 
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.new(:name => "Undefined Name")
    }
    assert_raises(TypeError) { 
      Vidalia::Artifact.new("n")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.new(:name => :n)
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.new(:name => ["not","a","string"])
    }
  end

  def test_add_and_get_child
    p_id = Vidalia::Artifact.define(:name => "parent",:type => Vidalia::Artifact) {$var = "p"} 
    a_id = Vidalia::Artifact.define(:name => "child A",:type => Vidalia::Artifact) {$var = "a"} 
    b_id = Vidalia::Artifact.define(:name => "child B",:type => Vidalia::Artifact) {$var = "b"} 
    c_id = Vidalia::Artifact.define(:name => "child C",:type => Vidalia::Artifact) {$var = "c"} 
    p = Vidalia::Artifact.new(:name => "parent")
    a = Vidalia::Artifact.new(:name => "child A")
    b = Vidalia::Artifact.new(:name => "child B")
    c = Vidalia::Artifact.new(:name => "child C")
    assert p.add_child(a) == a
    assert p.get_child("child A") == a
    assert p.get_child("none") == nil
    assert p.add_child(b) == b
    assert p.get_child("child A") == a
    assert p.get_child("child B") == b
    assert p.get_child("none") == nil
    assert p.add_child(c) == c
    assert p.get_child("child A") == a
    assert p.get_child("child B") == b
    assert p.get_child("child C") == c
    assert p.get_child("none") == nil
  end

  def test_add_child_validity_checking
    Vidalia::Artifact.define(:name => "parent",:type => Vidalia::Artifact) {$var = "p"} 
    Vidalia::Artifact.define(:name => "child",:type => Vidalia::Artifact) {$var = "c"} 
    p = Vidalia::Artifact.new(:name => "parent")
    c = Vidalia::Artifact.new(:name => "child")
    assert_raises(RuntimeError) { 
      p.add_child(2)
    }
    assert_raises(RuntimeError) { 
      p.add_child("child")
    }
  end

  def test_get_child_validity_checking
    Vidalia::Artifact.define(:name => "parent",:type => Vidalia::Artifact) {$var = "p"} 
    Vidalia::Artifact.define(:name => "child",:type => Vidalia::Artifact) {$var = "c"} 
    p = Vidalia::Artifact.new(:name => "parent")
    c = Vidalia::Artifact.new(:name => "child")
    assert p.add_child(c) == c
    assert_raises(RuntimeError) { 
      p.get_child(:child)
    }
    assert_raises(RuntimeError) { 
      p.get_child(c)
    }
  end

  def test_add_parent
    p_id = Vidalia::Artifact.define(:name => "parent",:type => Vidalia::Artifact) {$var = "p"} 
    c_id = Vidalia::Artifact.define(:name => "child",:type => Vidalia::Artifact) {$var = "c"} 
    p = Vidalia::Artifact.new(:name => "parent")
    c = Vidalia::Artifact.new(:name => "child")
    assert c.set_parent(p) == p
    assert c.parent == p
  end

  def test_add_parent_validity_checking
    Vidalia::Artifact.define(:name => "child",:type => Vidalia::Artifact) {$var = "c"} 
    c = Vidalia::Artifact.new(:name => "child")
    assert_raises(RuntimeError) { 
      c.set_parent(nil)
    }
    assert_raises(RuntimeError) { 
      c.set_parent("child")
    }
  end

end
