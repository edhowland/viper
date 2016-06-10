#!/usr/bin/env ruby
# test.rb - ...
require 'optparse'
require_relative 'vish.kpeg'

 str = ''
 opt_parser = OptionParser.new do |opt|
   opt.on('-e string', '--eval string', 'Evaluate string') do |string|
     str = string
   end
   opt.on('-f file', '--file file', 'Run file') do |file|
     str = File.read(file)
   end
end
opt_parser.parse!

parser = Vish.new(str)
#p parser
if parser.parse
  fail 'invalid result' unless parser.result.instance_of? Array
  p parser.result
  puts 'expanded'
  parser.result.each {|e| p e }
else
  puts 'syntax error'
end

