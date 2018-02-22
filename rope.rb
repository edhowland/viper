# rope.rb - how to instantiate a Rope instance: basic-rope

require 'rope'

# Note: the slice/insertion methods work like their string counterparts

rope = 'hello world'.to_rope
# Concatenating ropes/strings
rope << ' How are you?'
puts rope.to_s

# Slicing a rope
puts rope.slice(5..10).to_s
# replacing a portion of string
rope[0,3] = "Goodbye"
puts rope

