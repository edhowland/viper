# chord_bindings.rb - method chord_bindings - returns hash of chord combos

def chord_bindings
  {
    [:meta_d, :key_d] => ->(b) { say 'delete line' },
    [:meta_d, :shift_end] => ->(b) { say 'delete to end of line' }
  }
end

