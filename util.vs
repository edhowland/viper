# some utility functions for iivs testing
defn pf(cmd) {
  perf_command(:buf, :q, 1, :cmd, :norm)
}
defn gf(cmd) {
  fn=:norm[:cmd]
undefined?(:fn) && error('command not found')
#print("found function %{typeof(:fn)}")
  fn(:buf, :q) | prints()
}
stuf=openf('a0.vs')
buf=:stuf[0];q=:stuf[1]

