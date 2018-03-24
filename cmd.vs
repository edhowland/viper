# cmd.vs - get and process viper cmd
#
# the current put method
putm=put_tiny:
# putm=put_line:

defn f(b, q) { char(:b, :q) }
defn j(b, q) { down(:b, :q) }
defn k(b, q) { up(:b, :q) }
defn h(b, q) { left(:b, :q) }
defn l(b, q) { right(:b, :q) }
defn L(b, q) { line(:b, :q) }
defn gg(b, q) { top(:b, :q) }
defn G(b, q) { bottom(:b, :q) }

# register stuff
defn yy(b, q) { putm=put_line:; yank_line(:b, :q) }
defn p(b, q) { put(:b, :q, :putm) }
defn x(b, q) { putm=put_tiny:; delete_char(:b, :q) }
defn zero(b, q) { sol(:b, :q) }
defn dollar(b, q) { eol(:b, :q) }

# undo/redo stuff
defn u(b, q) { undo(:b, :q) }
defn ctrl_r(b, q) { redo(:b, :q) }

defn dd(b, q) { putm=put_line:; delete_line(:b, :q) }
#defn yy() { 'pressed yy' }

defn ZZ(b, q) { exit }

defn command(b, q) {
  cmd=getcmd()
  bind=binding()
fn=:bind[:cmd]
  %fn(:b, :q) | prints()
}

defn go() {
  line(:b, :q) | prints()
  loop { command(:b, :q) }
}



