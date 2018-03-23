# cmd.vs - get and process viper cmd
defn f(b, q) { char(:b, :q) }
defn j(b, q) { down(:b, :q) }
defn k(b, q) { up(:b, :q) }
defn h(b, q) { left(:b, :q) }
defn l(b, q) { right(:b, :q) }
defn L(b, q) { line(:b, :q) }
defn gg(b, q) { top(:b, :q) }
defn G(b, q) { bottom(:b, :q) }

# register stuff
defn yy(b, q) { yank_line(:b, :q) }

#defn dd() { 'pressed dd' }
#defn yy() { 'pressed yy' }

defn ZZ(b, q) { exit }

defn r(b, q) {
  cmd=getcmd()
  bind=binding()
fn=:bind[:cmd]
  %fn(:b, :q) | prints()
}

defn go() {
  line(:b, :q) | prints()
  loop { r(:b, :q) }
}



