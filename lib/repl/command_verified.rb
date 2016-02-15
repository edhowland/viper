# command_verified.rb - method command_verified? ensures dealiased sexps have valid command syms

def command_verified? sexps, bindings=command_bindings
  sexps.reduce(true)  {|i, s| i &= bindings[s[0]] }
end

