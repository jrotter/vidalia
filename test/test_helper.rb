require 'simplecov'
# Remove test files from code coverage report
SimpleCov.profiles.define 'test' do
  add_filter 'test'
end
SimpleCov.start 'test'

require 'minitest/autorun'
require_relative '../lib/vidalia'
