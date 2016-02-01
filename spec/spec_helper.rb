# spec_helper.rb - helper for Bungaku specs
require 'simplecov'
require 'simplecov-json'
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/bin/'
end if ENV['COV'] == '1'

require_relative 'load_path'
require 'minitest/autorun'

SRC_ROOT = File.expand_path(File.dirname(File.expand_path(__FILE__)) + '/..')
