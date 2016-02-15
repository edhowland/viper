# dealias.rb - method dealias given sym, finds alias, expands via parse!

def dealias sexp, &blk
  cmd, args = sexp
  return [ sexp ] if Viper::Session[:alias].nil?
  found = Viper::Session[:alias][cmd]
  unless found.nil?
    expanded = parse!(found)
    last = expanded[-1]
    last[1] = last[1] + args
    expanded[-1] = last
    yield if block_given?
    expanded
  else
    [ sexp ]
  end
end


def dealias_sexps sexps
  exp = false
  result = sexps.inject([]) {|i, j| i + dealias(j) { exp = true } }
  result = dealias_sexps(result) if exp
  result
end
