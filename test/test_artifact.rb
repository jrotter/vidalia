require 'minitest/autorun'
require 'test_helper'

class ArtifactTest < Minitest::Test

  def test_artifact_definition_happy_path
    Vidalia::Artifact.define(:name => "n",:type => Vidalia::Artifact) { $var = "dog" } 
    assert Vidalia::Artifact.get_definition_data("n",Vidalia::Artifact)[:name] == "n"
    assert Vidalia::Artifact.get_definition_data("n",Vidalia::Artifact)[:type] == Vidalia::Artifact
    assert Vidalia::Artifact.get_definition_data("n",Vidalia::Artifact)[:initialization_block].is_a?(Proc)

    Vidalia::Artifact.define(:name => "n",:type => Vidalia::Artifact,:otherstuff => "hello") {$var = "bird"} 
    assert Vidalia::Artifact.get_definition_data("n",Vidalia::Artifact)[:name] == "n"
    assert Vidalia::Artifact.get_definition_data("n",Vidalia::Artifact)[:type] == Vidalia::Artifact
    assert Vidalia::Artifact.get_definition_data("n",Vidalia::Artifact)[:otherstuff] == "hello"
    assert Vidalia::Artifact.get_definition_data("n",Vidalia::Artifact)[:initialization_block].is_a?(Proc)
  end

  def test_artifact_definition_parameter_checking
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define(:name => "n") {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define(:type => Vidalia::Artifact) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define() {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define(:name => 2,:type => Vidalia::Artifact) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.define(:name => "n",:type => 2) {|var| var = "dog"}
    }
  end

  def test_artifact_definition_and_creation_happy_path
    Vidalia::Artifact.define(:name => "n",:type => Vidalia::Artifact) {$var = "dog"} 
    $var = "cat"
    a = Vidalia::Artifact.new("n")
    assert $var == "dog"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Artifact)

    Vidalia::Artifact.define(:name => "n",:type => Vidalia::Artifact,:otherstuff => "hello") {$var = "N"} 
    Vidalia::Artifact.define(:name => "o",:type => Vidalia::Artifact,:foo => "bar") {$var = "O"} 
    Vidalia::Artifact.define(:name => "p",:type => Vidalia::Artifact,:monkey => "pants") {$var = "P"} 
    $var = "X"
    a = Vidalia::Artifact.new("n")
    assert $var == "N"
    assert a.name == "n"
    assert a.is_a?(Vidalia::Artifact)
    a = Vidalia::Artifact.new("o")
    assert $var == "O"
    assert a.name == "o"
    assert a.is_a?(Vidalia::Artifact)
    a = Vidalia::Artifact.new("p")
    assert $var == "P"
    assert a.name == "p"
    assert a.is_a?(Vidalia::Artifact)
  end

  def test_artifact_creation_error_checking
    Vidalia::Artifact.define(:name => "n",:type => Vidalia::Artifact) {$var = "dog"} 
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.new("Undefined Name")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.new(:name => "n")
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.new(:n)
    }
    assert_raises(RuntimeError) { 
      Vidalia::Artifact.new(["not","a","string"])
    }
  end

  def test_add_and_get_child
    Vidalia::Artifact.define(:name => "parent",:type => Vidalia::Artifact) {$var = "p"} 
    Vidalia::Artifact.define(:name => "child A",:type => Vidalia::Artifact) {$var = "a"} 
    Vidalia::Artifact.define(:name => "child B",:type => Vidalia::Artifact) {$var = "b"} 
    Vidalia::Artifact.define(:name => "child C",:type => Vidalia::Artifact) {$var = "c"} 
    p = Vidalia::Artifact.new("parent")
    a = Vidalia::Artifact.new("child A")
    b = Vidalia::Artifact.new("child B")
    c = Vidalia::Artifact.new("child C")
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
    p = Vidalia::Artifact.new("parent")
    c = Vidalia::Artifact.new("child")
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
    p = Vidalia::Artifact.new("parent")
    c = Vidalia::Artifact.new("child")
    assert p.add_child(c) == c
    assert_raises(RuntimeError) { 
      p.get_child(:child)
    }
    assert_raises(RuntimeError) { 
      p.get_child(c)
    }
  end

  def test_add_parent
    Vidalia::Artifact.define(:name => "parent",:type => Vidalia::Artifact) {$var = "p"} 
    Vidalia::Artifact.define(:name => "child",:type => Vidalia::Artifact) {$var = "c"} 
    p = Vidalia::Artifact.new("parent")
    c = Vidalia::Artifact.new("child")
    assert c.set_parent(p) == p
    assert c.parent == p
  end

  def test_add_parent_validity_checking
    Vidalia::Artifact.define(:name => "child",:type => Vidalia::Artifact) {$var = "c"} 
    c = Vidalia::Artifact.new("child")
    assert_raises(RuntimeError) { 
      c.set_parent(nil)
    }
    assert_raises(RuntimeError) { 
      c.set_parent("child")
    }
  end

end
