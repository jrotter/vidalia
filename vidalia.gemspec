Gem::Specification.new do |s|
  s.name        = 'vidalia'
  s.version     = '0.0.1'
  s.date        = '2017-01-08'
  s.summary     = 'Vidalia'
  s.description = 'Vidalia uses layers to simplify the creation and maintenance of API and database calls in your automated test suite.'
  s.add_development_dependency "minitest", [">= 0"]
  s.authors     = ["Jeremy Rotter"]
  s.email       = 'jeremy.rotter@gmail.com'
  s.files       = ['lib/vidalia.rb',
                   'lib/vidalia/application.rb',
                   'lib/vidalia/page.rb',
                   'lib/vidalia/region.rb',
                   'lib/vidalia/control.rb',
                   'lib/vidalia/artifact.rb']
  s.homepage    = 'https://github.com/jrotter/vidalia'
  s.license     = 'MIT'
end
