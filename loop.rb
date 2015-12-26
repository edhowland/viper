#!/usr/bin/env ruby
# loop.rb - event loop for editor

require 'io/console'
require_relative 'key_mappings'
require_relative 'key_press'
require_relative 'map_key'
require_relative 'lib/edit_buffer'
require_relative 'inserter'
require_relative 'bindings'

@buffer = Buffer.new(File.read('./spec/def.rb'))
@proc_bindings = make_bindings

def perform key, buf=@buffer, bnd=@proc_bindings
  prc = bnd[key]
  raise RuntimeError.new("No mapping for #{key}") if prc.nil?
  prc.call buf
end
  say 'editing: hit q when done'
loop do
  #x = key_press
  #puts 'x is'
  #p x
  #puts 'map x is'
  #p map_key(x)
  key = map_key(key_press)
  perform key
  break if key == :key_q
end

puts @buffer.to_s
