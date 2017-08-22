# chunkify.rb - method chunkify array - returns array chunked into 2 element arr

def chunkify arr
  result = []
  while  arr.length >= 2
    result << arr.shift(2)
  end
  result
end

