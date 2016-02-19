# search_bindings.rb - method search_bindings - hash of Procs matched to keys in search buffer

def search_bindings
  result = {}
  key_inserter_proc(result, ('a'..'z'))
  key_inserter_proc(result, ('A'..'Z'))
  key_inserter_proc(result, ('0'..'9'))

  # get old bindings from make_bindings
  existing = make_bindings

    # copy selected key bindings into our result
  [:backspace, :space, :del_at, :up, :down, :left, :right, :ctrl_a, :shift_pgup, :shift_pgdn, :shift_home, :shift_end, :ctrl_c, :ctrl_x, :ctrl_v].each do |key|
    result[key] = existing[key]
  end

  # some morecontrol keys
  [:ctrl_j, :ctrl_k, :ctrl_l, :ctrl_y].each do |key|
    result[key] = existing[key]
  end

  # punctuation
  [:period, :comma, :colon, :semicolon, :accent, :ampersand, :asterick, :dollar, :number, :at, :caret, :percent, :question].each do |key|
    result[key] = existing[key]
  end
  result
end

