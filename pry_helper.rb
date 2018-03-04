# pry_slice.rb - pry helper for Slice and friends

require_relative 'slice'
require_relative 'slice_table'


def zero_9
  s = '0123456789'
  return s, Slice.new(s)
end

def st_9
  s, = zero_9
  SliceTable.new s
end