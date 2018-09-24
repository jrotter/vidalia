module Vidalia

  class Mysql

    require 'mysql2'

    # Instantiate a database object
    #
    # @param printable_name [String] Human-readable name of the database (for 
    #   logging purposes)
    # @param host [String] Hostname of the database
    # @param port [String] Port on which the database can be accessed.
    # @param database_name [String] Name of the database (in MySQL)
    # @param username [String] Database account username
    # @param password [String] Database account password
    # @param sslca [String] Full file path of the SSL CA bundle
    # @example
    #   db = Vidalia::Mysql.new(
    #     printable_name: 'Application MySQL Database',
    #     host: 'sql.server.com',
    #     database_name: 'appdb01',
    #     username: 'admin',
    #     password: 'passw0rd',
    #     sslca: '/tmp/bundle.pem'
    #   )
    #
    def initialize(
          printable_name:,
          host:,
          port: '3306',
          database_name:,
          username:,
          password:,
          sslca: nil
        )
      @printable_name = printable_name
      @username = username
      @password = password
      @host = host
      @database_name = database_name
      @port = port
      @sslca = sslca
    end

    # Run a query against the database
    #
    # This method opens a database connection and ensures that it is closed in
    #   the event of an error.
    #
    # @param query [String] SQL query to be run against the database.
    # @returns results [Array] Array of rows of query results
    # @example
    #   db = Vidalia::Mysql.new(
    #     printable_name: 'Application MySQL Database',
    #     host: 'sql.server.com',
    #     database_name: 'appdb01',
    #     username: 'admin',
    #     password: 'passw0rd',
    #     sslca: '/tmp/bundle.pem'
    #   )
    #   db.run(query: "SELECT * FROM my_table")
    #
    def run(query:)
      Vidalia::log("SQL query text: \"#{query}\"",:style => :debug)
      open_connection
      result = launch_query_command(query: query)
      if result.size > 0
        count = 1
        result.each do |r|
          Vidalia::log("SQL query result (#{count}): \"#{r.inspect}\"",:style => :debug)
          count += 1
        end
      else
        Vidalia::log("SQL query: NO RESULTS FOUND",:style => :debug)
      end
    rescue Exception => e
      raise e
    else
      return result
    ensure
      close_connection
    end

    private

    # Open a connection to the database
    #
    # @example
    #   db = Vidalia::Mysql.new(
    #     printable_name: 'Application MySQL Database',
    #     host: 'sql.server.com',
    #     database_name: 'appdb01',
    #     username: 'admin',
    #     password: 'passw0rd',
    #     sslca: '/tmp/bundle.pem'
    #   )
    #   db.open_connection
    #
    def open_connection
      if sslca then
        @db = Mysql2::Client.new(
          host: @host, 
          username: @username, 
          password: @password, 
          port: @port, 
          database: @database_name,
          sslca: @sslca)
      else
        @db = Mysql2::Client.new(
          host: @host, 
          username: @username, 
          password: @password, 
          port: @port, 
          database: @database_name)
      end
    end

    # Run a query against the database
    #
    # @param query [String] SQL query to be run against the database
    # @returns results [Array] Array of rows of query results
    # @example
    #   db = Vidalia::Mysql.new(
    #     printable_name: 'Application MySQL Database',
    #     host: 'sql.server.com',
    #     database_name: 'appdb01',
    #     username: 'admin',
    #     password: 'passw0rd',
    #     sslca: '/tmp/bundle.pem'
    #   )
    #   db.open
    #   my_results = db.query("SELECT * FROM my_table")
    #
    def launch_query_command(query:)
      @db.query(query, as: :hash)
    end

    # Close a connection to the database
    #
    # @example
    #   db = Vidalia::Mysql.new(
    #     printable_name: 'Application MySQL Database',
    #     host: 'sql.server.com',
    #     database_name: 'appdb01',
    #     username: 'admin',
    #     password: 'passw0rd',
    #     sslca: '/tmp/bundle.pem'
    #   )
    #   db.open_connection
    #   db.close_connection
    #
    def close_connection
      @db.close if @db
    end
  end
end
