# inserter.rb - method inserter returns a [:sym, Proc}

def inserter value
  key = ('key_' + value).to_sym
  prc = ->(b) { b.ins value; say value }
  [key, prc]
end
