describe Vidalia::Entity do
  parallelize_me!

  describe 'initialize' do
    before do
      class << self
        attr_accessor :mixin_ran, :block_ran
      end
      @mixin_ran = nil
      @block_ran = nil

      test = self
      @test_mixin = Module.new do
        define_method(:test_method) { test.mixin_ran = true }
      end
      @def_block = proc { test.block_ran = true }
    end

    it 'should initialize an entity' do
      @block_ran.must_be_nil
      @mixin_ran.must_be_nil
      # def_block runs on entity initialization, mixin is included, but the method
      # inside is not called yet
      ent = Vidalia::Entity.new(connection_mixin: @test_mixin,
                                definition_block: @def_block)
      @block_ran.must_equal true
      @mixin_ran.must_be_nil
      ent.must_respond_to :test_method

      ent.test_method

      @mixin_ran.must_equal true
    end
  end

  describe 'method_missing' do
    before do
        class << self
          attr_accessor :opens, :closes, :reads, :updates
        end
        @opens = 0
        @closes = 0
        @reads = 0
        @updates = 0

      test = self
      interface 'My Interface' do
        open { test.opens += 1 }
        close { |_conn| test.closes += 1 }
        entity 'My Entity' do
          read { |_conn| test.reads += 1 }
          update { |_conn| test.updates += 1 }
        end
      end
    end

    it 'should define read and update, call them while implicitly calling ' \
      'open and close' do
      # No methods have been called yet, entity was only created
      ent = Vidalia::Interface.get('My Interface').entity('My Entity')
      @opens.must_equal 0
      @closes.must_equal 0
      @reads.must_equal 0
      @updates.must_equal 0

      ent.read
      @opens.must_equal 1
      @closes.must_equal 1
      @reads.must_equal 1
      @updates.must_equal 0

      ent.update
      @opens.must_equal 2
      @closes.must_equal 2
      @reads.must_equal 1
      @updates.must_equal 1
    end
  end

  describe 'element' do
    before do
      interface 'My Interface' do
        open { true }
        close { |_conn| false }
        entity 'My Entity' do
          read do |_conn|
            @my_inferred_element = 'my inferred element'
            @my_explicit_element = 'my explicit element'
          end

          element 'My Explicit Element' do |ent|
            get { (ent.instance_variable_get :@my_explicit_element).upcase }
            set { |val| ent.instance_variable_set :@my_explicit_element, val }
          end
        end
      end
      @ent = Vidalia::Interface.get('My Interface').entity('My Entity')
      @ent.read
    end

    it 'should call an inferred element with a getter and setter' do
      @ent.element(:my_inferred_element).get.must_equal 'my inferred element'
      @ent.element('My Inferred Element').set 'my edited element'
      @ent.element('my InFerred element').get.must_equal 'my edited element'
    end

    it 'should call an explicitly defined element with a getter and setter' do
      @ent.element(:my_explicit_element).get.must_equal 'MY EXPLICIT ELEMENT'
      @ent.element('My Explicit Element').set 'my edited explicit element'
      @ent.element('My Explicit Element').get.must_equal 'MY EDITED EXPLICIT ELEMENT'
    end

    it 'should fail when calling an element that has not been defined and ' \
      'cannot be inferred' do
      proc { @ent.element 'My Fake Element' }.must_raise Vidalia::NoElementError
      proc { @ent.element :my_fake_element }.must_raise Vidalia::NoElementError
    end
  end
end
