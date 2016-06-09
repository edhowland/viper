#!/usr/bin/env ruby
# test.rb - ...

require_relative 'vish.kpeg'

parser = Vish.new(ARGV[0])
#p parser
if parser.parse
  fail 'invalid result' unless parser.result.instance_of? Array
  p parser.result
  puts 'expanded'
  parser.result.each {|e| p e }
else
  puts 'syntax error'
end

