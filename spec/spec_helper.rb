# spec_helper.rb - helper for Bungaku specs
require 'simplecov'
require 'simplecov-json'
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
end


#SimpleCov.start
require_relative 'load_path'
require 'minitest/autorun'
