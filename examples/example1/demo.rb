require 'vidalia'

# Set a logroutine for Vidalia
Vidalia::set_logroutine { |logstring|
  puts logstring
}

# This is just scaffolding for the test.  Build the database.
Vidalia.log("Building the database for this test")
require './db_helper'

# Load in the object definition - every Vidalia program will have to do this
require './user_object'

# Get the Interface object (which has been pre-set by the control layer)
db = Vidalia::Interface.get("Application DB")

# Get the Object we'll be working with from our Interface
user_object = db.object("User")

# Set the ID for the object we want to read
user_object.element("ID").update 7

# Call our "read" method to get the data for the ID we specified
user_object.read

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
user_object.read
user_object.element("ID").verify 7
user_object.element("First Name").verify "George"
user_object.element("Last Name").verify "Costanza"
user_object.element("Username").verify "realarchitect"

