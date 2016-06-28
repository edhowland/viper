# spec_helper.rb - spec helper for core package

require 'minitest/reporters/json_reporter'
require_relative '../load_path'

Minitest::Reporters.use!( Minitest::Reporters::JsonReporter.new)
require 'minitest/autorun'