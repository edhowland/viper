#!/usr/bin/env ruby
# test.rb - ...
require 'optparse'
require_relative 'vish.kpeg'
options = {expand: false}
 str = ''
 opt_parser = OptionParser.new do |opt|
   opt.on('-e string', '--eval string', 'Evaluate string') do |string|
     str = string
   end
   opt.on('-f file', '--file file', 'Run file') do |file|
     str = File.read(file)
   end
  opt.on('-x', '--expand', 'Expand result') do
    options[:expand] = true
  end
end
opt_parser.parse!

def expand element, level=0
  element.each do |e|
    if e.instance_of? Array
      expand e, level+1
    else
      print "\t" * level
      p e
    end
  end
end

  
 # actually parse the arg string
parser = Vish.new(str)
#p parser
if parser.parse
  fail "invalid result: type: #{parser.result.class}, value: #{parser.result}" unless parser.result.instance_of? Array
  p parser.result
  if options[:expand]
    puts 'expanded'
#  parser.result.each {|e| p e }
    expand(parser.result)
end
else
  puts 'syntax error'
end

