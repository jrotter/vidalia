# Vidalia

Vidalia uses layers to simplify the creation and maintenance of API and database calls in your automated test suite.

A typical automated test suite can be broken down into layers:

* A **workflow layer** on top, which dictates the user's path through the application.  Think in terms of verbs and user stories: "As a user, when I create a new message, I expect it to be sent to the desired recipient."  The workflow layer cares about user actions and results, not about the mechanics of entering or retrieving data.
* A **control layer** beneath, which defines the specific interactions with the application.  This control layer would be implemented using API calls or direct database calls and cares only about getting data into and out of the application.

Vidalia allows for easy separation of the workflow and control layers by sitting between them.  At the control layer, it provides a simple infrastructure for creation and maintenance of API/database calls.  At the workflow layer, it provides a set of basic test directives, allowing for easier manipulation of data without having to worry about the details of the underlying interfaces.

## Installation

Install the Vidalia gem from the command line or include it in your [Bundler file](https://bundler.io/)

## Building Documentation

To build the Vidalia documentation set locally, clone the repo and run `rake yard`. The documentation set is not currently hosted.

## Running Tests

To run the unit test suite locally, clone the repo and run `rake test`

## Interfaces, Entities, and Elements

Vidalia allows you to define three basic artifacts: interfaces, entities, and elements
An **interface** is at the top layer of the Vidalia hierarchy. It provides behavior for connecting to a data source along with a collection of entities.
An **entity** is a collection of data elements that can be manipulated on and populated from the data source.  Entity operations (e.g. create, read, update, delete) or can be defined by the user.
An **element** is a single piece of data within an entity.  Elements have a set of directives associated with them to enable easier implementation of your test automation.

### Element Directives

Manipulation and verification of each element is built around the two primary directives `get` and `set`:

- `get` - reads and returns the current value of the element from the entity.  Usually performed after data is retreived via an entity operation.
- `set` - updates the current value of the element in preparation for the next operation on the entity.

Once these primary directives are defined, Vidalia puts them together to build the following directives for free:

- `retrieve` - reads and returns the current value from the element.  Does not log anything.  (This is the user-callable version of `get`.)
- `update` - sets a new element value.  Logs the value of the element both before and after the change for auditing purposes.
- `confirm` - tests the value of the element, returning `true` if the input matches the value of the element and `false` otherwise.  Does not log anything.
- `verify`  - tests the value of the element, raising an exception if the input does not match the value of the element.  Returns `true` otherwise.  Logs successes for auditing purposes.

## Getting Started

The code examples used below are all taken from the Vidalia repository in the `examples/example1` directory.  In this directory, we will be automating control of user data in the database created by the `db_helper.rb` script.

Remember, Vidalia breaks the code into two layers, so we'll define those layers in different files.  The workflow layer will be defined in `demo.rb`, but let's start by using Vidalia to define the control layer in `user_entity.rb`.

### Define the Interface

Our first step is to define an interface. An Interface needs an `open` and `close` block, which specifies how a database (or other data source) connection is opened and closed. The `open` block should open and return a connection to the data source. As you will see soon, this connection is passed to entity operations. The `close` block must accept an open connection as its only argument and simply close the connection. The `close` block is called at the end of the entity operation.

    interface 'Application DB' do |inter|
      open { SQLite3::Database.open 'users.db' }
      close { |db| db.close }
      # ...
    end

#### Define an Entity

Now we can define our entity within our interface. The entity definition will contain a code block to specify its operations.

    interface 'Application DB' do |inter|
      # ...
      entity 'User' do
        # ...
      end
      # ...
    end

#### Define Entity Operations

In our example, we will define operations to create, retrieve, update, and delete a User entity.  The database connection returned by the interface's `open` method will automatically be passed in to each entity operation as the first argument to the block. The interface's `close` method will be called on the database connection implicitly when the Entity operation ends.  These defintions all exist within the block provided to `entity`.

Let's start with "create":

    entity 'User' do
      # ...
      create do |db| # Interface's `open` called here
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
      end # Interface's `close` called here
      # ...
    end

Next we define a "read" operation. Any number of additional arguments can be provided to the entity operation blocks, as seen in the single `inhash` parameter:

    entity 'User' do
      # ...
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
      # ...
    end

Operations for "update" and "delete" are defined in the `user_entity.rb` file.

#### Define Elements

In most cases, elements only need simple get and set functionality and don't need to be explicitly defined. In these cases, element names will resolve to instance varibles names. In this example, element names `'ID'` resolves to `@id`, `'First Name'` resolves to `@first_name`, `'Last Name'` resolves to `@last_name`, and `'Username'` resolves to `@username`.

Elements can be explicitly defined within an entity if they need special behavior, or their desired names for the workflow layer should not resolve directly to the entity's instance variables.

    element 'Full Name' do |ent|
      get do
        "#{ent.intance_variable_get :@first_name} " \
          "#{ent.intance_variable_get :@first_name}"
      end

      set do |name|
        sp = name.split(' ')
        ent.instance_variable_set(:@first_name, sp[0])
        ent.instance_variable_set(:@last_name, sp[1])
      end
    end

The `ent` argument to the element's block is a reference to the entity the element is contained in. This allows the element to access the entity's instance variables.
A current limitation is that Vidalia assumes each explicit element has an explicitly defined `get` AND `set` method. When both are present, all directives will be available for the element.

### Invoke the Workflow

The workflow layer is utlized in `demo.rb`.
A logging routine must be passed to Vidalia. This simply prints logs to standard output:

    Vidalia.set_logroutine { |logstring| puts logstring }

Once the `users.db` database is created, interface we defined in `user_entity.rb` can be used:

    db = Vidalia::Interface.get('Application DB')

Next, we can create an empty User entity:

    user = db.entity('User')

This queries the user with an ID of 7 and populates the elements of the entity with the user data from the database:

    user.read(:id => 7)

The test happens to know the user at ID 7 is Art VanDelay. Now that the entity's data is populated, the `verify` directive to can be used to check if the entity contains what we expected it to contain:

    user.element('First Name').verify 'Art'
    user.element('Last Name').verify 'VanDelay'
    user.element('Full Name').verify 'Art VanDelay'
    user.element('Username').verify 'realarchitect'

Notice how elements are automatically matched up based on the names used in the entity's instance variables from the definition. `'First Name'` resolves to `@first_name`, `'Last Name'` resolves to `@last_name`, and `'Username'` resolves to `@username`.
As described above, these directives will log that they have successfully verified the values or they will raise an exception if they fail.

With user data in hand, now it can be manipulated:

    user.element('First Name').update 'George'
    user.element('Last Name').update 'Costanza'

Then changes can be saved to the database:

    user.update

By running `read` then `verify` again, the database updates can be verified

    user.read(:id => 7)
    user.element('ID').verify 7
    user.element('First Name').verify 'George'
    user.element('Last Name').verify 'Costanza'
    user.element('Full Name').verify 'George Costanza'
    user.element('Username').verify 'realarchitect'

The `delete` method (see definition in `user_entity.rb`) will remove the entity from the database:

    user.delete(:id => 7)

The `confirm` demonstrates the entity was deleted by attempting to `read` the deleted entity:

    user.read(:id => 7)
    if user.element('ID').confirm nil
      Vidalia.log('Entity was successfully deleted!')
    else
      raise 'Delete did not work!  Entity read came back with data!'
    end
