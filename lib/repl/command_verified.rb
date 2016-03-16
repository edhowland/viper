# command_verified.rb - method command_verified? ensures dealiased sexps have valid command syms

def command_verified?(sexps, bindings = Viper::Session[:commands])
  sexps.reduce(true) { |a, e| a && !bindings[e[0]].nil? }
end
