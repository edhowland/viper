# cmd.vs - get and process viper cmd
defn j(b, q) { down(:b, :q) }
defn k(b, q) { up(:b, :q) }
defn h(b, q) { left(:b, :q) }
defn l(b, q) { right(:b, :q) }

defn dd() { 'pressed dd' }
defn yy() { 'pressed yy' }

defn ZZ(b, q) { exit }

defn r(b, q) {
  cmd=getcmd()
  bind=binding()
fn=:bind[:cmd]
  %fn(:b, :q) | prints()
}


