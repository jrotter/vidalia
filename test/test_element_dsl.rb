require 'minitest/autorun'
require 'test_helper'

class ElementTest < Minitest::Test

  def setup
    # Clean up the Interface Definitions
    Vidalia::InterfaceDefinition.reset
    Vidalia::set_logroutine { |logstring|
      logstring #No need to print anything out here
    }
  end

  def test_element_definition_happy_path_dsl
    $var = "X"
    i = o = e = nil
    i = interface 'i' do
      o = object 'o' do
        e = element 'e' do
          init { $var = 'E' }
        end
      end
    end
    assert e.is_a?(Vidalia::Element)
    assert o.number_of_children == 1
    assert o.get_child("e") == e
    assert $var == "X"
  end

  def test_element_instantiation_no_block_dsl
    $var = "X"
    interface 'i' do
      init { $var = "I" }
      object 'o' do
        init { $var = "O" }
        element 'e'
      end
    end
    int = Vidalia::Interface.get("i")
    assert $var == "I"
    obj = int.object("o")
    assert $var == "O"
    ele = obj.element("e")
    assert $var == "O"
  end

  def test_element_get_definition_happy_path_dsl
    interface 'i' do
      object 'o' do
        element 'e1' do
          get { |instring| instring }
        end
        element 'e2' do
          get { |inhash| inhash[:b] }
        end
        element 'e3' do
          get { |do_not_care| "zebra" }
        end
        element 'e4' do
          get { "Egypt" }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele2 = obj.element("e2")
    ele3 = obj.element("e3")
    ele4 = obj.element("e4")
    assert ele1.get("hi") == "hi"
    assert ele2.get({:a => "A",:b => "B",:c => "C"}) == "B"
    assert ele3.get() == "zebra"
    assert ele4.get() == "Egypt"
  end

  def test_element_get_definition_parameter_checking_dsl
    assert_raises(RuntimeError) do
      interface 'i' do
        object 'o' do
          e1 = element 'e1' do
            init { $var = 'E1' }
            # Will raise an error because up to one value can be passed to the
            # get
            get { |string1,string2,string3| "#{string1}#{string2}#{string3}" }
          end
        end
      end
    end
  end

  def test_element_set_definition_happy_path_dsl
    $var = "X"
    interface 'i' do
      object 'o' do
        element 'e1' do
          set { |instring| $var = instring }
        end
        element 'e2' do
          set { |inhash| $var = inhash[:b] }
        end
        element 'e3' do
          set { |do_not_care| $var = "zebra" }
        end
        element 'e4' do
          set { $var = "Egypt" }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele2 = obj.element("e2")
    ele3 = obj.element("e3")
    ele4 = obj.element("e4")
    $var = "X"
    ele1.set("hi")
    assert $var == "hi"
    ele2.set({:a => "A",:b => "B",:c => "C"})
    assert $var == "B"
    ele3.set()
    assert $var == "zebra"
    ele4.set()
    assert $var == "Egypt"
  end

  def test_element_set_definition_parameter_checking_dsl
    assert_raises(RuntimeError) do
      interface 'i' do
        object 'o' do
          e1 = element 'e1' do
            init { $var = 'E1' }
            # Will raise an error because up to one value can be passed to the
            # set
            set { |string1,string2,string3| "#{string1}#{string2}#{string3}" }
          end
        end
      end
    end
  end

  def test_element_retrieve_definition_happy_path_dsl
    $var = "X"

    interface 'i' do
      object 'o' do
        element 'e1' do
          retrieve { |instring| $var = instring }
        end
        element 'e2' do
          retrieve { |inhash| $var = inhash[:b] }
        end
        element 'e3' do
          retrieve { |do_not_care| $var = "zebra" }
        end
        element 'e4' do
          retrieve { $var = "Egypt" }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele2 = obj.element("e2")
    ele3 = obj.element("e3")
    ele4 = obj.element("e4")
    $var = "X"
    ele1.retrieve("hi")
    assert $var == "hi"
    ele2.retrieve({:a => "A",:b => "B",:c => "C"})
    assert $var == "B"
    ele3.retrieve()
    assert $var == "zebra"
    ele4.retrieve()
    assert $var == "Egypt"
  end

  def test_element_retrieve_definition_parameter_checking_dsl
    assert_raises(RuntimeError) do
      interface 'i' do
        object 'o' do
          element 'e1' do
            retrieve { |string1,string2,string3| "#{string1}#{string2}#{string3}" }
          end
        end
      end
    end
  end

  def test_element_verify_definition_happy_path_dsl
    $var = "X"

    interface 'i' do
      object 'o' do
        element 'e1' do
          verify { |instring| $var = instring }
        end
        element 'e2' do
          verify { |inhash| $var = inhash[:b] }
        end
        element 'e3' do
          verify { |do_not_care| $var = "zebra" }
        end
        element 'e4' do
          verify { $var = "Egypt" }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele2 = obj.element("e2")
    ele3 = obj.element("e3")
    ele4 = obj.element("e4")
    $var = "X"
    ele1.verify("hi")
    assert $var == "hi"
    ele2.verify({:a => "A",:b => "B",:c => "C"})
    assert $var == "B"
    ele3.verify()
    assert $var == "zebra"
    ele4.verify()
    assert $var == "Egypt"
  end

  def test_element_verify_definition_parameter_checking_dsl
    assert_raises(RuntimeError) do
      interface 'i' do
        object 'o' do
          element 'e1' do
            verify { |string1,string2,string3| "#{string1}#{string2}#{string3}" }
          end
        end
      end
    end
  end

  def test_element_confirm_definition_happy_path_dsl
    $var = "X"

    interface 'i' do
      object 'o' do
        element 'e1' do
          confirm { |instring| $var = instring }
        end
        element 'e2' do
          confirm { |inhash| $var = inhash[:b] }
        end
        element 'e3' do
          confirm { |do_not_care| $var = "zebra" }
        end
        element 'e4' do
          confirm { $var = "Egypt" }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele2 = obj.element("e2")
    ele3 = obj.element("e3")
    ele4 = obj.element("e4")
    $var = "X"
    ele1.confirm("hi")
    assert $var == "hi"
    ele2.confirm({:a => "A",:b => "B",:c => "C"})
    assert $var == "B"
    ele3.confirm()
    assert $var == "zebra"
    ele4.confirm()
    assert $var == "Egypt"
  end

  def test_element_confirm_definition_parameter_checking_dsl
    interface 'i' do
      object 'o' do
        element 'e1' do
          confirm { |instring| $var = instring }
        end
        element 'e2' do
          confirm { |inhash| $var = inhash[:b] }
        end
        element 'e3' do
          confirm { |do_not_care| $var = "zebra" }
        end
        element 'e4' do
          confirm { $var = "Egypt" }
        end
      end
    end
  end
  def test_element_update_definition_happy_path_dsl
    $var = "X"

    interface 'i' do
      object 'o' do
        element 'e1' do
          update { |instring| $var = instring }
        end
        element 'e2' do
          update { |inhash| $var = inhash[:b] }
        end
        element 'e3' do
          update { |do_not_care| $var = "zebra" }
        end
        element 'e4' do
          update { $var = "Egypt" }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele2 = obj.element("e2")
    ele3 = obj.element("e3")
    ele4 = obj.element("e4")
    $var = "X"
    ele1.update("hi")
    assert $var == "hi"
    ele2.update({:a => "A",:b => "B",:c => "C"})
    assert $var == "B"
    ele3.update()
    assert $var == "zebra"
    ele4.update()
    assert $var == "Egypt"
  end

  def test_element_update_definition_parameter_checking_dsl
    interface 'i' do
      object 'o' do
        element 'e1' do
          update { |instring| $var = instring }
        end
        element 'e2' do
          update { |inhash| $var = inhash[:b] }
        end
        element 'e3' do
          update { |do_not_care| $var = "zebra" }
        end
        element 'e4' do
          update { $var = "Egypt" }
        end
      end
    end
  end

  def test_element_generic_get_only_dsl
    $var = "X"

    interface 'i' do
      object 'o' do
        element 'e1' do
          init { $var = 'E1' }
          get { $var }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    $var = 1
    assert ele1.get("foo") == 1
    $var = 2
    assert ele1.retrieve("foo") == 2
    $var = 3
    assert ele1.confirm(3)
    $var = 4
    ele1.verify(4)
  end

  def test_element_generic_get_and_set_dsl
    $var = "X"

    interface 'i' do
      object 'o' do
        element 'e1' do
          init { $var = 'E1' }
          get { $var }
          set { |value| $var = value }
        end
      end
    end

    int = Vidalia::Interface.get("i")
    obj = int.object("o")
    ele1 = obj.element("e1")
    ele1.set(1)
    assert ele1.get("foo") == 1
    ele1.update(2)
    assert ele1.retrieve("foo") == 2
    ele1.set(3)
    assert ele1.confirm(3)
    ele1.update(4)
    ele1.verify(4)
  end

end
