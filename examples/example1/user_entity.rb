require 'vidalia'
require 'sqlite3'

# Define the interface - `inter` is a reference to the defined interface
interface 'Application DB' do |inter|

  open { SQLite3::Database.open 'users.db' }
  close { |db| db.close }

  ###############################################################################
  # Define a user entity
  # In this case, we will be using direct database calls to interrogate User
  # entities.  The entity definition itself should simply define initial values
  # for the data elements within this entity.
  ###############################################################################
  entity 'User' do
    ###############################################################################
    # Tell Vidalia how to create a User entity in the database
    ###############################################################################
    create do |db|
      sql_string = "INSERT INTO users VALUES("
      sql_string << @id.to_s
      sql_string << ","
      sql_string << @first_name.to_s
      sql_string << ","
      sql_string << @last_name.to_s
      sql_string << ","
      sql_string << @username.to_s
      sql_string << ")"
      Vidalia.log("Adding a user with DB call \"#{sql_string}\"")
      db.execute sql_string
    end

    ###############################################################################
    # Tell Vidalia how to read the User entity
    #
    # Vidalia will expect all elements to be read AFTER this method is invoked
    ###############################################################################
    read do |db, inhash|
      if inhash[:id]
        sql_string = "SELECT * FROM users WHERE id = #{inhash[:id]};"
        Vidalia.log("Reading user ID=#{inhash[:id]} with DB call \"#{sql_string}\"")
      elsif inhash[:username]
        sql_string = "SELECT * FROM users WHERE username = #{inhash[:username]};"
        Vidalia.log("Reading user username=#{inhash[:username]} with DB call \"#{sql_string}\"")
      end
      results = db.execute sql_string

      # Handle empty array
      results << [nil,nil,nil,nil] if results.size == 0

      result = results[0]
      @id = result.shift
      @first_name = result.shift
      @last_name = result.shift
      @username = result.shift
    end

    ###############################################################################
    # Tell Vidalia how to update the User entity
    #
    # Vidalia will expect all elements to be set BEFORE this method is invoked
    ###############################################################################
    update do |db|
      sql_string = "Update users SET first_name=\'"
      sql_string << @first_name.to_s
      sql_string << "\', last_name=\'"
      sql_string << @last_name.to_s
      sql_string << "\', username=\'"
      sql_string << @username.to_s
      sql_string << "\' WHERE id="
      sql_string << @id.to_s
      sql_string << ";"
      Vidalia.log("Updating user ID=#{@id} with DB call \"#{sql_string}\"")
      db.execute sql_string
    end

    ###############################################################################
    # Tell Vidalia how to delete the User entity
    #
    # Vidalia will expect all elements to be set BEFORE this method is invoked
    ###############################################################################
    delete do |db, inhash|
      if inhash[:id]
        sql_string = "DELETE FROM users WHERE id = #{inhash[:id]};"
        Vidalia.log("Deleting user ID=#{inhash[:id]} with DB call \"#{sql_string}\"")
      elsif inhash[:username]
        sql_string = "DELETE * FROM users WHERE username = #{inhash[:username]};"
        Vidalia.log("Deleting user username=#{inhash[:username]} with DB call \"#{sql_string}\"")
      end
      db.execute sql_string
    end

    element 'Full Name' do |ent|
      get do
        "#{ent.instance_variable_get :@first_name} " \
          "#{ent.instance_variable_get :@last_name}"
      end

      set do |name|
        sp = name.split(' ')
        ent.instance_variable_set(:@first_name, sp[0])
        ent.instance_variable_set(:@last_name, sp[1])
      end
    end
  end
end
