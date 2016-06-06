# dealias.rb - method dealias given sym, finds alias, expands via parse!

def dealias(sexp, seen = [], &_blk)
  cmd, args = sexp
  return [sexp] if Viper::VFS["viper"]["alias"].nil? || seen.member?(cmd)
  found = Viper::VFS["viper"]["alias"][cmd.to_s]
  if found.nil?
    [sexp]
  else
    expanded = parse!(found)
    last = expanded[-1]
    last[1] = last[1] + args
    expanded[-1] = last
    yield(cmd) if block_given?
    expanded
  end
end

def dealias_sexps(sexps, seen = [])
  exp = false
  result = sexps.inject([]) { |a, e| a + dealias(e, seen) { |al| exp = true; seen << al } }
  result = dealias_sexps(result, seen) if exp
  result
end
