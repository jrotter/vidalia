require 'minitest/autorun'
require 'test_helper'

class InterfaceTest < Minitest::Test

  def setup
    # Clean up the Interface Definitions
    Vidalia::InterfaceDefinition.reset
  end

  def test_interface_definition_happy_path
    $var = "cat"
    a = Vidalia::Interface.define(:name => "n") {$var = "dog"} 
    assert a.is_a?(Vidalia::InterfaceDefinition)
    assert a.interface.is_a?(Vidalia::Interface)
    assert $var == "cat"
  end

  def test_interface_definition_parameter_checking
    assert_raises(RuntimeError) { 
      Vidalia::Interface.define(:name => 2) {|var| var = "dog"}
    }
    assert_raises(RuntimeError) { 
      Vidalia::Interface.define() {|var| var = "dog"}
    }
  end

end
