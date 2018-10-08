require 'rake/testtask'
require 'yard'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test_**.rb']
  t.verbose = true
  t.ruby_opts = ['-r "./test/test_helper"']
end

desc "Run tests"
task :default => :test

YARD::Rake::YardocTask.new do |t|
  excluded_files = ['lib/qa-infrastructure/med_data_helper.rb']
  t.files = Dir['README.rdoc', 'lib/**/*.rb'] - excluded_files
end
