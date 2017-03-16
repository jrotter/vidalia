require 'vidalia'

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
  @id = nil
  @first_name = nil
  @last_name = nil
  @username = nil
}

###############################################################################
# Tell Vidalia how to create the User object
# 
# Vidalia will expect all elements to be set BEFORE this method is invoked
###############################################################################
user_object.add_method(:name => "create") {
  db = SQLite3::Database.open "users.db"
  sql_string = "INSERT INTO Users VALUES("
  sql_string << @id.to_s
  sql_string << ","
  sql_string << @first_name.to_s
  sql_string << ","
  sql_string << @last_name.to_s
  sql_string << ","
  sql_string << @username.to_s
  sql_string << ")"
  db.execute sql_string
  db.close
}

###############################################################################
# Tell Vidalia how to read the User object
#
# Vidalia will expect all elements to be read AFTER this method is invoked
###############################################################################
user_object.add_method(:name => "read") {
  db = SQLite3::Database.open "users.db"
  sql_string = "SELECT * FROM Users WHERE id = #{@id};"
  results = db.execute sql_string
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
}

###############################################################################
# Tell Vidalia how to delete the User object
#
# Vidalia will expect all elements to be set BEFORE this method is invoked
###############################################################################
user_object.add_method(:name => "delete") {
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


