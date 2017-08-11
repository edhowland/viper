#!/usr/bin/env ruby
# mk_gnometerm.rb - creates file ./etc/keymaps/gnometerm.json
# usage: ./mk_gnometerm.rb > etc/keymaps/gnometerm.json

# keycodes generated in Gnome Terminal emulator in Linux w/Gnome window manager
# are the Escape (27) followed by the ascii of the character pressed with the Alt key.
# They get translated to meta_a, meta_b, meta_c ... meta_z
require 'json'

#'!../' pu2=':..@' pu3='[..`' pu4='{..~'

def pu(value, name)
  [[27, value.ord], "meta_#{name}"]
end

def metas
a = (('a'..'z').to_a + ('0'..'9').to_a).map { |e| [[27, e.ord], "meta_#{e}"] }
a << pu(',', 'comma')
a << pu('.', 'period')
a << pu(';', 'semicolon')
a.unshift [[0], 'ctrl_space']
  a
end

puts metas.to_h.to_json
