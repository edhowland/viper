#!/usr/bin/env ruby
# test.rb - ...

require_relative 'vish.kpeg'

parser = Vish.new(ARGV[0])
#p parser
if parser.parse
  p parser.result
else
  puts 'syntax error'
end

