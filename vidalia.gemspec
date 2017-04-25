Gem::Specification.new do |s|
  s.name        = 'vidalia'
  s.version     = '0.0.2'
  s.date        = '2017-04-25'
  s.summary     = 'Vidalia'
  s.description = 'Vidalia uses layers to simplify the creation and maintenance of API and database calls in your automated test suite.'
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
                   'lib/vidalia/element.rb']
  s.homepage    = 'https://github.com/jrotter/vidalia'
  s.license     = 'MIT'
end
