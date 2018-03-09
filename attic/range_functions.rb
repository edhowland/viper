# range_functions.rb - Various range functions

# make an empty range, when, applied to a string or array, returns emtpy 
def empty_range
  (-1..0)
end

def split_range(r, inter, pos)
  l_fin = (inter.zero? ? 0 : inter - 1)
  return Range.new(r.first, l_fin), Range.new(inter+pos, r.last)
end

def join_range(left, right)
  (left.first)..(right.last)
end


# offset_of given 2 ranges, a logical and concrete, and a logical offset, return
#  concrete offset

def offset_of(logical, concrete, offset)
  concrete.to_a[logical.to_a.index(offset)]
end
