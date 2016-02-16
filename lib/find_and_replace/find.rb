# find.rb - method find - match string pattern in buffer

def find buffer, pattern
  buffer.srch_fwd pattern
end


def rev_find buffer, pattern
  buffer.srch_back pattern
end
