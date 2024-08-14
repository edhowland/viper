#!/usr/bin/env ruby
# checks Vish lang syntax using new parser

require_relative 'pry/ipl'


  # main
  p = pf(ARGV.first)

begin
  p.p_root
  puts "#{ARGV.first}: Syntax ok"
  exit(0)
rescue => err
  $stderr.puts "Syntax error : #{err.message}"
  exit(1)
end

