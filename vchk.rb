#!/usr/bin/env ruby
# checks Vish lang syntax using new parser

require_relative 'pry/ipl'


def syn_chk(fname)
  p = pf(fname)
  
begin
  p.p_root
  puts "#{fname}: Syntax ok"
rescue => err
  $stderr.puts "#{fname}: Syntax error : #{err.message}"
  exit(1)
end
end

  # main

ARGV.each do |f|
  puts "Checking #{f}"
  syn_chk(f)
end