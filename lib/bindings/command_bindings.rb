# command_bindings.rb - method command_bindings returns hash of command procs

def command_bindings
  {
    :q => ->(b, *args) { exit }
  }
end
