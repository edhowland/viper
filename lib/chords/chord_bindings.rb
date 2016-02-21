# chord_bindings.rb - method chord_bindings - returns hash of chord combos

def chord_bindings
  {
    [:meta_d, :key_d] => ->(b) {b.front_of_line; b.set_mark; b.down; $clipboard = b.cut; say 'line' },
    [:meta_d, :shift_home] => ->(b) { b.set_mark; b.front_of_line; $clipboard = b.cut; say 'to start of line' },
    [:meta_d, :shift_pgup] => ->(b) { b.set_mark; b.beg; $clipboard = b.cut; say 'to top of buffer' },
    [:meta_d, :shift_pgdn] => ->(b) { b.set_mark; b.fin; $clipboard = b.cut; say 'to bottom of buffer' },
    [:meta_d, :shift_end] => ->(b) { b.set_mark; b.back_of_line; $clipboard = b.cut; say 'to end of line' }
  }
end

