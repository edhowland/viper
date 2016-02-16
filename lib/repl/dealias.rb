# dealias.rb - method dealias given sym, finds alias, expands via parse!

def dealias sexp, seen=[], &blk
  cmd, args = sexp
  return [ sexp ] if Viper::Session[:alias].nil? || seen.member?(cmd)
  found = Viper::Session[:alias][cmd]
  unless found.nil?
    expanded = parse!(found)
    last = expanded[-1]
    last[1] = last[1] + args
    expanded[-1] = last
    yield(cmd) if block_given?
    expanded
  else
    [ sexp ]
  end
end


def dealias_sexps sexps, seen=[]
  exp = false
  result = sexps.inject([]) {|i, j| i + dealias(j, seen) {|al| exp = true; seen << al } }
  result = dealias_sexps(result, seen) if exp
  result
end
