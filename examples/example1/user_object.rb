require 'vidalia'
require 'sqlite3'

###############################################################################
# Define the interface.  Under the covers, Vidalia will only define the
# interface if it hasn't been defined already.
###############################################################################
app_db = Vidalia::Interface.define(:name => "Application DB")


###############################################################################
# Define this object.  

# In this case, we will be using direct database calls to interrogate User 
# objects.  The object definition itself should simply define initial values 
# for the data elements within this object.
###############################################################################
user_object = Vidalia::Object.define(:name => "User", :parent => app_db) {
  singleton_class.class_eval { attr_accessor :id }
  @id = nil
  singleton_class.class_eval { attr_accessor :first_name }
  @first_name = nil
  singleton_class.class_eval { attr_accessor :last_name }
  @last_name = nil
  singleton_class.class_eval { attr_accessor :username }
  @username = nil
}

###############################################################################
# Tell Vidalia how to create the User object
# 
# Vidalia will expect all elements to be set BEFORE this method is invoked
###############################################################################
user_object.add_method(:name => "create") {
  db = SQLite3::Database.open "users.db"
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
  db.close
}

###############################################################################
# Tell Vidalia how to read the User object
#
# Vidalia will expect all elements to be read AFTER this method is invoked
###############################################################################
user_object.add_method(:name => "read") { |inhash|
  db = SQLite3::Database.open "users.db"
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
  db.close
}

###############################################################################
# Tell Vidalia how to update the User object
#
# Vidalia will expect all elements to be set BEFORE this method is invoked
###############################################################################
user_object.add_method(:name => "update") {
  db = SQLite3::Database.open "users.db"
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
  db.close
}

###############################################################################
# Tell Vidalia how to delete the User object
#
# Vidalia will expect all elements to be set BEFORE this method is invoked
###############################################################################
user_object.add_method(:name => "delete") { |inhash|
  db = SQLite3::Database.open "users.db"
  if inhash[:id] 
    sql_string = "DELETE FROM users WHERE id = #{inhash[:id]};"
    Vidalia.log("Deleting user ID=#{inhash[:id]} with DB call \"#{sql_string}\"")
  elsif inhash[:username]
    sql_string = "DELETE * FROM users WHERE username = #{inhash[:username]};"
    Vidalia.log("Deleting user username=#{inhash[:username]} with DB call \"#{sql_string}\"")
  end
  db.execute sql_string
  db.close
}


id_element = Vidalia::Element.define(:name => "ID", :parent => user_object) 
id_element.add_get { |opts|
  @parent.id
}
id_element.add_set { |value|
  @parent.id = value
}


first_name_element = Vidalia::Element.define(:name => "First Name", :parent => user_object) 
first_name_element.add_get { |opts|
  @parent.first_name
}
first_name_element.add_set { |value|
  @parent.first_name = value
}


last_name_element = Vidalia::Element.define(:name => "Last Name", :parent => user_object) 
last_name_element.add_get { |opts|
  @parent.last_name
}
last_name_element.add_set { |value|
  @parent.last_name = value
}


username_element = Vidalia::Element.define(:name => "Username", :parent => user_object) 
username_element.add_get { |opts|
  @parent.username
}
username_element.add_set { |value|
  @parent.username = value
}


