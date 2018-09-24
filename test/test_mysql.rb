require 'minitest/autorun'
require 'test_helper'

class MysqlTest < Minitest::Test

  describe 'TestMysql' do
    before do
      # Clean up the Interface Definitions
      Vidalia::set_logroutine { |logstring|
        logstring #No need to print anything out here
      }
    end

    it 'Mysql instance can be created when specifying a port' do
      db = Vidalia::Mysql.new(
        printable_name: 'a',
        host: 'b',
        port: '1234',
        database_name: 'c',
        username: 'd',
        password: 'e',
        sslca: 'f'
      )
      db.printable_name.must_equal 'a'
      db.host.must_equal 'b'
      db.port.must_equal '1234'
      db.database_name.must_equal 'c'
      db.username.must_equal 'd'
      db.password.must_equal 'e'
      db.sslca.must_equal 'f'
    end
  
    it 'Mysql instance can be created when not specifying a port' do
      db = Vidalia::Mysql.new(
        printable_name: 'l',
        host: 'm',
        database_name: 'n',
        username: 'o',
        password: 'p',
        sslca: 'q'
      )
      db.printable_name.must_equal 'l'
      db.host.must_equal 'm'
      db.port.must_equal '3306'
      db.database_name.must_equal 'n'
      db.username.must_equal 'o'
      db.password.must_equal 'p'
      db.sslca.must_equal 'q'
    end

    it 'Mysql query sends appropriate query to the database' do
      db = Vidalia::Mysql.new(
        printable_name: 'l',
        host: 'm',
        database_name: 'n',
        username: 'o',
        password: 'p',
        sslca: 'q'
      )
      Thread.current[:open_mysql_connection] = false
      Thread.current[:close_mysql_connection] = false
      result = db.run(query: ['test'])
      result.must_equal ['test']
      Thread.current[:open_mysql_connection].must_equal true
      Thread.current[:close_mysql_connection].must_equal true
    end

    it 'Mysql query recovery still closes database connection' do
      db = Vidalia::Mysql.new(
        printable_name: 'l',
        host: 'm',
        database_name: 'n',
        username: 'o',
        password: 'p',
        sslca: 'q'
      )
      Thread.current[:open_mysql_connection] = false
      Thread.current[:close_mysql_connection] = false
      Proc.new{
        result = db.run(query: 'KABOOM')
      }.must_raise
      Thread.current[:open_mysql_connection].must_equal true
      Thread.current[:close_mysql_connection].must_equal true
    end
  end
end
