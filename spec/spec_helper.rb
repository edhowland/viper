# spec_helper.rb - helper for Bungaku specs

# Possibly require SimpleCov libs if user has ~/.load_simplecov
require_relative 'load_simplecov' if File.exist?(File.expand_path('~/.load_simplecov'))

require_relative 'load_path'
require 'minitest/autorun'

SRC_ROOT = File.expand_path(File.dirname(File.expand_path(__FILE__)) + '/..')
