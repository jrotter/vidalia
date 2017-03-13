require 'vidalia'

# This is just scaffolding for the test.  Build the database.
require './db_helper'

# Load in the object definition
require './user_object'

# Set a logroutine for Vidalia
Vidalia::set_logroutine { |logstring|
  puts logstring
}

# Get the Interface object (which has been pre-set by the control layer)
db = Vidalia::Interface.new(:name => "Application DB")

user_object = db.object("User")



###################3


# Update the "Party" value
app.page("Sample Page").control("Party").update "Republicrat"

# Verify that the "Party" value is what we set it to
app.page("Sample Page").control("Party").verify "Republicrat"

# Submit the change
app.page("Sample Page").control("Set My Party").navigate

# Set a new nickname for President Adams
app.page("Sample Page").region("President" => "John Adams").control("Nickname").update "Sammy's Bro"

# Verify the new nickname for President Adams
app.page("Sample Page").region("President" => "John Adams").control("Nickname").verify "Sammy's Bro"

# View the Biography for President Jefferson
app.page("Sample Page").region("President" => "Thomas Jefferson").control("Biography").navigate
