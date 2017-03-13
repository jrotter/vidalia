require 'vidalia'

###############################################################################
# Define the interface.  Under the covers, Vidalia will only define the
# interface if it hasn't been defined already.
###############################################################################
i_tok = Vidalia::Interface.define(:name => "Application DB")


###############################################################################
# Define this object.  

# In this case, we will be using direct database calls to interrogate User 
# objects.  The object definition itself should simply define initial values 
# for the data elements within this object.
###############################################################################
o_tok = Vidalia::Object.define(:name => "User", :parent => i_tok) {
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
Vidalia::Object.add_method(:name => "create", :token => o_tok) {
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
Vidalia::Object.add_method(:name => "read", :token => o_tok) {
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
Vidalia::Object.add_method(:name => "update", :token => o_tok) {
}

###############################################################################
# Tell Vidalia how to delete the User object
#
# Vidalia will expect all elements to be set BEFORE this method is invoked
###############################################################################
Vidalia::Object.add_method(:name => "delete", :token => o_tok) {
}


e_tok = Vidalia::Element.define(:name => "ID", :parent => obj) 
Vidalia::Element.add_get(:token => e_tok) { |opts|
  @id
}
Vidalia::Element.add_set(:token => e_tok) { |value|
  @id = value
}


t = Vidalia::Element.define(:name => "First Name", :parent => obj)
Vidalia::Element.add_get(:token => e_tok) { |opts|
  @first_name
}
Vidalia::Element.add_set(:token => e_tok) { |value|
  @first_name = value
}


e_tok = Vidalia::Element.define(:name => "Last Name", :parent => obj) 
Vidalia::Element.add_get(:token => e_tok) { |opts|
  @last_name
}
Vidalia::Element.add_set(:token => e_tok) { |value|
  @last_name = value
}


e_tok = Vidalia::Element.define(:name => "Username", :parent => obj) 
Vidalia::Element.add_get(:token => e_tok) { |opts|
  @username
}
Vidalia::Element.add_set(:token => e_tok) { |value|
  @username = value
}



