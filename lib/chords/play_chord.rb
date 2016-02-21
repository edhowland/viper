# play_chord.rb - method play_chord - find Proc for chord and call it

def play_chord buffer, first
  second = map_key(key_press)
  prc = chord_bindings[[first, second]]
  raise OperationNotPermitted if prc.nil?
  prc.call(buffer)
end

