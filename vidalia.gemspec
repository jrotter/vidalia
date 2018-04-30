Gem::Specification.new do |s|
  s.name        = 'vidalia'
  s.version     = '1.0.0'
  s.date        = '2018-09-27'
  s.summary     = 'Vidalia'
  s.description = 'Vidalia uses layers to simplify the creation and ' \
                  'maintenance of API and database calls in your automated ' \
                  'test suite.'
  s.add_runtime_dependency "mysql2", '~> 0.5.2'
  s.authors     = ['Jeremy Rotter']
  s.email       = 'jeremy.rotter@gmail.com'
  s.files       = ['lib/vidalia.rb',
                   'lib/vidalia/interface.rb',
                   'lib/vidalia/entity.rb',
                   'lib/vidalia/element.rb',
                   'lib/vidalia/mysql.rb',
                   'lib/vidalia/name.rb']
  s.homepage    = 'https://github.com/jrotter/vidalia'
  s.license     = 'MIT'
end
