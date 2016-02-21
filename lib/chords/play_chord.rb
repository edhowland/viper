# play_chord.rb - method play_chord - find Proc for chord and call it

def stanzas
  {
    meta_d: 'Delete'
  }
end

def play_chord buffer, first
  stanza = stanzas[first]
  say stanza
  second = map_key(key_press)
  prc = chord_bindings[[first, second]]
  raise BindingNotFound if prc.nil?
  prc.call(buffer)
end

