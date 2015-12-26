# key_mappings.rb - method key_mappings returns a hash of keys to syms
def key_mappings
    {
  "\033[A" => :up,
  "\033[B" => :down,
  "\033[C" => :right,
  "\033[D" => :left
  }
end
