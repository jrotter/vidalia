require 'vidalia'

# Load in the entity definition - every Vidalia program will have to do this
require './user_entity'

Vidalia.set_logroutine { |logstring| puts logstring }

# This is just scaffolding for the test.  Build the database.
Vidalia.log('Building the database for this test')
require './db_helper'

# Get the Interface entity (which has been pre-set by the control layer)
db = Vidalia::Interface.get 'Application DB'

# Get an Entity we'll be working with from our Interface
user = db.entity('User')

# Call our "read" method to get the data for a specified ID
user.read(:id => 7)

# Verify that the data is what we expect
user.element('ID').verify 7
user.element('First Name').verify 'Art'
user.element('Last Name').verify 'VanDelay'
user.element('Full Name').verify 'Art VanDelay'
user.element('Username').verify 'realarchitect'

# Now that we have the data, update the user's name
user.element('First Name').update 'George'
user.element('Last Name').update 'Costanza'

# Commit our name changes
user.update

# Now reread the entity and verify that our changes worked
user.read(:id => 7)
user.element('ID').verify 7
user.element('First Name').verify 'George'
user.element('Last Name').verify 'Costanza'
user.element('Full Name').verify 'George Costanza'
user.element('Username').verify 'realarchitect'

# Now delete the entity
user.delete(:id => 7)

# Now attempt to reread the entity and confirm that we got null data back
user.read(:id => 7)
if user.element('ID').confirm nil
  Vidalia.log('Entity was successfully deleted!')
else
  raise 'Delete did not work! Entity read came back with data!'
end
