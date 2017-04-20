require 'vidalia'

# Load in the object definition - every Vidalia program will have to do this
require './user_object'

# Set a logroutine for Vidalia
Vidalia::set_logroutine { |logstring|
  puts logstring
}

# This is just scaffolding for the test.  Build the database.
Vidalia.log("Building the database for this test")
require './db_helper'

# Get the Interface object (which has been pre-set by the control layer)
db = Vidalia::Interface.get("Application DB")

# Get the Object we'll be working with from our Interface
user_object = db.object("User")

# Call our "read" method to get the data for a specified ID
user_object.read(:id => 7)

# Verify that the data is what we expect
user_object.element("ID").verify 7
user_object.element("First Name").verify "Art"
user_object.element("Last Name").verify "VanDelay"
user_object.element("Username").verify "realarchitect"

# Now that we have the data, update the user's name
user_object.element("First Name").update "George"
user_object.element("Last Name").update "Costanza"

# Commit our name changes
user_object.update

# Now reread the object and verify that our changes worked
user_object.read(:id => 7)
user_object.element("ID").verify 7
user_object.element("First Name").verify "George"
user_object.element("Last Name").verify "Costanza"
user_object.element("Username").verify "realarchitect"

# Now delete the object
user_object.delete(:id => 7)

# Now attempt to reread the object and confirm that we got null data back
user_object.read(:id => 7)
if user_object.element("ID").confirm nil
  Vidalia.log("Object was successfully deleted!")
else
  raise "Delete didn't work!  Object read came back with data!"
end

