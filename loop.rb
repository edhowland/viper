#!/usr/bin/env ruby
# loop.rb - event loop for editor
require_relative 'lib/viper'
@buffer = Buffer.new ''
@proc_bindings = make_bindings

def perform key, buf=@buffer, bnd=@proc_bindings
  prc = bnd[key]
  begin
    raise RuntimeError.new("No mapping for #{key}") if prc.nil?
    prc.call buf
  rescue => err
    say BELL
  end
end
  say 'editing: hit Ctrl-Q when done'
loop do
  key = map_key(key_press)
  break if key == :ctrl_q
  perform key
end

puts @buffer.to_s
