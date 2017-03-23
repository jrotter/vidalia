require 'sqlite3'

def build_db
  db_data = [
    {
      id: 1,
      first_name: 'John',
      last_name: 'Smith',
      username: 'jsmith'
    },
    {
      id: 2,
      first_name: 'Jane',
      last_name: 'Doe',
      username: 'jdoe'
    },
    {
      id: 3,
      first_name: 'Abe',
      last_name: 'Lincoln',
      username: 'honestabe'
    },
    {
      id: 4,
      first_name: 'Besty',
      last_name: 'Ross',
      username: 'rossboss'
    },
    {
      id: 5,
      first_name: 'Chuck',
      last_name: 'Smith',
      username: 'csmith'
    },
    {
      id: 6,
      first_name: 'Benjamin',
      last_name: 'Franklin',
      username: 'bigben'
    },
    {
      id: 7,
      first_name: 'Art',
      last_name: 'VanDelay',
      username: 'realarchitect'
    },
    {
      id: 8,
      first_name: 'Scooby',
      last_name: 'Doo',
      username: 'scoobyd'
    },
    {
      id: 9,
      first_name: 'Alfred',
      last_name: 'Pennyworth',
      username: 'butler'
    },
    {
      id: 10,
      first_name: 'Bill',
      last_name: 'Cat',
      username: 'billthecat'
    }
  ]
  db = SQLite3::Database.new "users.db"
  db.execute "DROP TABLE users;"
  db.execute "CREATE TABLE users(id INT, first_name TEXT, last_name TEXT, username TEXT);"
  db_data.each do |data|
    db.execute "INSERT INTO users VALUES ('#{data[:id]}','#{data[:first_name]}','#{data[:last_name]}','#{data[:username]}');"
  end
  db.close
end

build_db
