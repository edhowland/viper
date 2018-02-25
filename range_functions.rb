# range_functions.rb - Various range functions

def split_range(r, inter, pos)
  return Range.new(r.first, inter - 1), Range.new(inter+pos, r.last)
end


# offset_of given 2 ranges, a logical and concrete, and a logical offset, return
#  concrete offset

def offset_of(logical, concrete, offset)
  concrete.to_a[logical.to_a.index(offset)]
end
