# pry_slice.rb - pry helper for Slice and friends

require_relative 'slice'

def zero_9
  s = '0123456789'
  return s, Slice.new(s)
end