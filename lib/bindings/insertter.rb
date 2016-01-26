# inserter.rb - method inserter returns a [:sym, Proc}

def insert_sym(value)
  ->(b) { b.ins value; say value }
end

def inserter(value)
  key = ('key_' + value).to_sym
  prc = ->(b) { b.ins value; say value }
  [key, prc]
end
