# head_or_all.rb - method head_or_all [t, ..] - returns first item if one
#  item or entire array

def head_or_all(arr)
  f, *r = arr
  return f if r.empty?
  arr
end
