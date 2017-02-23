# distance.rb - method distance, given an array of integers, computes adjacent 
# neighbors difference

def distance arr
  off = arr[1..-1]
  off << off[-1]
  arr.zip(off).map {|e| e[1] - e[0] }
end