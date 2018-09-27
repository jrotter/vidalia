Gem::Specification.new do |s|
  s.name        = 'vidalia'
  s.version     = '0.1.1'
  s.date        = '2018-09-24'
  s.summary     = 'Vidalia'
  s.description = 'Vidalia uses layers to simplify the creation and maintenance of API and database calls in your automated test suite.'
  s.add_runtime_dependency "mysql2", '~> 0.5.2'
  s.add_development_dependency 'minitest', '~> 0'
  s.authors     = ["Jeremy Rotter"]
  s.email       = 'jeremy.rotter@gmail.com'
  s.files       = ['lib/vidalia.rb',
                   'lib/vidalia/element_definition.rb',
                   'lib/vidalia/interface_definition.rb',
                   'lib/vidalia/object_definition.rb',
                   'lib/vidalia/artifact.rb',
                   'lib/vidalia/interface.rb',
                   'lib/vidalia/object.rb',
                   'lib/vidalia/element.rb',
                   'lib/vidalia/dsl.rb',
                   'lib/vidalia/mysql.rb']
  s.homepage    = 'https://github.com/jrotter/vidalia'
  s.license     = 'MIT'
end
