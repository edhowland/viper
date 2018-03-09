# pry_slice.rb - pry helper for Slice and friends

require_relative 'slice'
require_relative 'slice_table'
require_relative 'sliced_buffer'


def zero_9
  s = '0123456789'
  return s, Slice.new(s)
end

def st_9
  s, = zero_9
  SliceTable.new s
end

def s_56
  s = st_9
  s.split_at(Span.new(5..6))
  s
end



def si
  x = st_9
  x.cleave_at(0,5)
  x.insert_at 1, 'ABCD'
  x
end

def hello
  SlicedBuffer.new 'hello world'
end