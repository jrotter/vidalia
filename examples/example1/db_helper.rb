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
    }
  ]
  db = SQLite3::Database.new "users.db"
  db.execute "CREATE TABLE users(id INT, first_name TEXT, last_name TEXT, username TEXT);"
  db_data.each do |data|
    db.execute "INSERT INTO users VALUES ('#{data[:id]}','#{data[:first_name]}','#{data[:last_name]}','#{data[:username]}');"
  end
  db.close
end

