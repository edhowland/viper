# bindings.rb - returns hash of key bindings to procs

def make_bindings
  result = {}
('a'..'z').inject(result) {|i,j| s,p=inserter(j); i[s] = p; i}
  result
end
