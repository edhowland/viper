# chunk2.rb: chunkify an array by groups of 2

def chunk2 list
  list.zip(list[1..])
end

def nodots pairs
  pairs.reject {|e| e.member?('..') }
end

def unchunk pairs
  pairs.reduce([]) {|i, j| i << j[0] }
end