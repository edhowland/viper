# dealias.rb - method dealias given sym, finds alias, expands via parse!

def dealias sexp
  cmd, args = sexp
  return [ sexp ] if Viper::Session[:alias].nil?
  found = Viper::Session[:alias][cmd]
  unless found.nil?
    expanded = parse!(found)
    last = expanded[-1]
    last[1] = last[1] + args
    expanded[-1] = last
    expanded
  else
    [ sexp ]
  end
end


def dealias_sexps sexps
  sexps.inject([]) {|i, j| i + dealias(j) }
end
