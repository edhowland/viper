# load_simplecov.rb - requires for simplecov gem
require 'simplecov'
require 'simplecov-json'
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/bin/'
end if ENV['COV'] == '1'

$simplecov_loaded = true
