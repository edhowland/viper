# cmd.vs - get and process viper cmd
defn j() { 'pressed j' }
defn k() { 'pressed k' }
defn h() { 'pressed h' }
defn l() { 'pressed l' }
defn dd() { 'pressed dd' }
defn yy() { 'pressed yy' }
defn ZZ() { exit }

defn r() {
  cmd=getcmd()
  bind=binding()
fn=:bind[:cmd]
%fn
}


