#!/usr/bin/env ruby
# loop.rb - event loop for editor
require_relative 'requires'
@buffer = Buffer.new ''
@proc_bindings = make_bindings

def perform key, buf=@buffer, bnd=@proc_bindings
  prc = bnd[key]
  raise RuntimeError.new("No mapping for #{key}") if prc.nil?
  prc.call buf
end
  say 'editing: hit Ctrl-C when done'
loop do
  key = map_key(key_press)
  break if key == :ctrl_c
  perform key
end

puts @buffer.to_s
