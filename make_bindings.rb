# bindings.rb - returns hash of key bindings to procs

def make_bindings
  result = {}
('a'..'z').inject(result) {|i,j| s,p=inserter(j); i[s] = p; i}
  ('A'..'Z').inject(result) {|i, j| s,p = inserter(j); i[s] = p; i}
  ('0'..'9').inject(result) {|i, j| s,p = inserter(j); i[s] = p; i}
  result[:space] = inserter(' ')[1]
  result[:return] = ->(b) { b.ins "\n"; say 'return' }
  result[:tab] = ->(b) { b.ins '  '; say 'tab' }
  result[:ctrl_l] = ->(b) { say b.line }
  result[:ctrl_j] = ->(b) { say b.at }
  result[:right] = ->(b) { b.fwd; say b.at}
  result[:left] = ->(b) { b.back; say b.at}
  result[:up] = ->(b) { b.up; say b.line }
  result[:down] = ->(b) { b.down; say b.line }
  result[:backspace] =->(b) { ch= b.del; say "delete #{ch}" }
  result
end
