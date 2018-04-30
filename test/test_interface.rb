describe Vidalia::Interface do
  parallelize_me!

  describe 'get' do
    before do
      @my_inter = interface 'My Interface' do |inter|
        'Do the needful'
      end

      @my_other_inter = interface 'My Other Interface' do
        'Doing the other needful'
      end
    end

    it 'should find interfaces that exist' do
      Vidalia::Interface.get('My Interface').must_equal @my_inter
      Vidalia::Interface.get(:my_interface).must_equal @my_inter

      Vidalia::Interface.get('My Other Interface').must_equal @my_other_inter
      Vidalia::Interface.get('my_other INTERface').must_equal @my_other_inter
    end

    it 'should fail when looking for an interface that does not exist' do
      proc do
        Vidalia::Interface.get('Not an interface')
      end.must_raise Vidalia::NoInterfaceError

      proc do
        Vidalia::Interface.get('')
      end.must_raise Vidalia::NoInterfaceError
    end
  end

  describe 'open and close' do
    before do
      class Vidalia::Interface
        attr_reader :connection_mixin
      end
    end

    after do
      class Vidalia::Interface
        undef_method :connection_mixin
      end
    end

    it 'should define an open method in the mixin of the interface' do
      ct = 0

      interface 'My Openable Interface' do
        open { ct += 1 }
      end

      obj = Object.new
      class << obj
        include Vidalia::Interface.get('My Openable Interface').connection_mixin
      end

      ct.must_equal 0
      obj.open
      ct.must_equal 1
    end

    it 'should define a close method in the mixin of the interface' do
      ct = 0

      interface 'My Openable Interface' do
        close { |new_ct| ct = new_ct }
      end

      obj = Object.new
      class << obj
        include Vidalia::Interface.get('My Openable Interface').connection_mixin
      end

      ct.must_equal 0
      obj.close 2
      ct.must_equal 2
    end
  end

  describe 'entity' do
    before do
      interface 'My Interface with Entity' do |inter|
        open { true }
        entity 'Readable Entity' do
          read { |conn, id| @last_action = "Read #{id}" }
        end
      end

      class Vidalia::Entity
        attr_reader :last_action
      end
    end

    after do
      class Vidalia::Entity
        undef_method :last_action
      end
    end

    it 'should create separate entities based on the same DSL spec' do
      inter = Vidalia::Interface.get 'My Interface with Entity'
      ent1 = inter.entity 'Readable Entity'
      ent2 = inter.entity :readable_entity

      ent1.wont_equal ent2
      ent1.last_action.must_be_nil
      ent2.last_action.must_be_nil

      ent1.read '1'
      ent2.read '2'

      # shows they have separate instance variables
      ent1.wont_equal ent2
      ent1.last_action.must_equal 'Read 1'
      ent2.last_action.must_equal 'Read 2'
    end

    it 'should raise an error when an entity is not found' do
      proc do
        Vidalia::Interface.get('My Interface with Entity').entity('Bad Entity')
      end.must_raise Vidalia::NoEntityError
    end
  end
end
