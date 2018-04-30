describe Vidalia::Element do
  parallelize_me!

  before do
    class << self
      attr_accessor :count
    end
    @count = 0
  end

  describe 'initialize' do
    before do
      class Vidalia::Element
        attr_accessor :human_name
      end
    end

    after do
      class Vidalia::Element
        undef_method :human_name, :human_name=
      end
    end

    it 'should create an element with only a name and a defintion block' do
      test = self
      test_def = proc { test.count += 1 }
      test_def_arg = proc do |arg|
        arg.must_be_nil
        test.count += 1
      end

      @count.must_equal 0
      elem = Vidalia::Element.new('New Element', definition_block: test_def)
      elem.human_name.must_equal 'New Element'
      @count.must_equal 1

      elem = Vidalia::Element.new :new_element, definition_block: test_def_arg
      elem.human_name.must_equal 'new_element'
      @count.must_equal 2
    end

    it 'should create an element and pass an argument into the definition block' do
      test = self
      test_def = proc do |arg|
        arg.must_equal 'parent'
        test.count += 1
      end

      @count.must_equal 0
      elem = Vidalia::Element.new('New Element',
                                  parent_entity: 'parent',
                                  definition_block: test_def)
      @count.must_equal 1
    end
  end

  describe 'generic_hooks, retrieve, verify, confirm, and update' do
    before do
      @logtext = ''
      Vidalia.set_logroutine { |str| @logtext << "#{str}\n" }

      interface 'My Interface' do
        open { true }
        close { |_conn| false }
        entity 'My Entity' do
          read do |_conn|
            @my_inferred_element = 'my inferred element'
            @my_explicit_element = 'my explicit element'
          end

          element 'My Explicit Element' do |ent|
            get { "elem: #{ent.instance_variable_get :@my_explicit_element}" }
            set { |val| ent.instance_variable_set :@my_explicit_element, val }
          end
        end
      end
    end

    it 'should add generic retrieve, verify, confirm, and update methods for ' \
      'an explicitly defined element through the DSL' do
      ent = Vidalia::Interface.get('My Interface').entity('My Entity')
      ent.read

      elem = ent.element('My Explicit Element')

      # Get and set
      elem.get.must_equal 'elem: my explicit element'
      elem.set 'my EXPLICIT element'
      elem.get.must_equal 'elem: my EXPLICIT element'

      elem.retrieve.must_equal 'elem: my EXPLICIT element'

      # Verify
      proc do
        elem.verify 'elem: my explicit element'
      end.must_raise RuntimeError
      elem.verify 'elem: my EXPLICIT element'
      @logtext.must_equal "Verified My Explicit Element to be \"elem: my EXPLICIT element\"\n"

      # Confirm
      elem.confirm('elem: my explicit element').must_equal false
      elem.confirm('elem: my EXPLICIT element').must_equal true

      # Update
      elem.update 'my explicit element'
      @logtext.must_equal "Verified My Explicit Element to be \"elem: my EXPLICIT element\"\n" \
        "Entering My Explicit Element: \"my explicit element\" (was \"elem: " \
        "my EXPLICIT element\")\n"

      elem.get.must_equal 'elem: my explicit element'
    end

    it 'should add generic retrieve, verify, confirm, and update methods for ' \
      'an implicitly defined element' do
      ent = Vidalia::Interface.get('My Interface').entity('My Entity')
      ent.read

      elem = ent.element('My Inferred Element')

      # Get and set
      elem.get.must_equal 'my inferred element'
      elem.set 'my INFERRED element'
      elem.get.must_equal 'my INFERRED element'

      elem.retrieve.must_equal 'my INFERRED element'

      # Verify
      proc do
        elem.verify 'my inferred element'
      end.must_raise RuntimeError
      elem.verify 'my INFERRED element'
      @logtext.must_equal "Verified My Inferred Element to be \"my INFERRED element\"\n"

      # Confirm
      elem.confirm('my inferred element').must_equal false
      elem.confirm('my INFERRED element').must_equal true

      # Update
      elem.update 'my inferred element'
      @logtext.must_equal "Verified My Inferred Element to be \"my INFERRED element\"\n" \
        "Entering My Inferred Element: \"my inferred element\" (was \"" \
        "my INFERRED element\")\n"
      elem.get.must_equal 'my inferred element'

      elem.update 'my inferred element'
      @logtext.must_equal "Verified My Inferred Element to be \"my INFERRED element\"\n" \
        "Entering My Inferred Element: \"my inferred element\" (was \"" \
        "my INFERRED element\")\n" \
        "My Inferred Element is already set to \"my inferred element\"\n"
    end
  end
end
