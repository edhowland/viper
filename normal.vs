# normal.vs - get and process viper cmd for normal mode
#
# the current put method
putm=put_tiny:
# putm=put_line:

defn normal() {
  defn f(_b, q) { char(:_b, :q) }
  defn j(_b, q) { down(:_b, :q) }
  defn k(_b, q) { up(:_b, :q) }
  defn h(_b, q) { left(:_b, :q) }
  defn l(_b, q) { right(:_b, :q) }
  defn L(_b, q) { line(:_b, :q) }
  defn gg(_b, q) { top(:_b, :q) }
  defn G(_b, q) { bottom(:_b, :q) }

  # register stuff
  defn yy(_b, q) { putm=put_line:; yank_line(:_b, :q) }
  defn yquotem(_b, q) { putm=put_tiny:; yank_region(:_b, :q, region_of(:_b, :q, m:)) }
  defn y0(_b, q) { putm=put_tiny:; yank_region(:_b, :q, to_sol(:q)); ' yanked to fron of line ' }
  defn ydollar(_b, q) { putm=put_tiny:;  yank_region(:_b, :q, to_eol(:q)); ' yanked to end of line ' }
  defn dquotem(_b, q) { putm=put_tiny:; delete_region(:_b, :q, region_of(:_b, :q, m:)) }
  defn p(_b, q) { put(:_b, :q, :putm) }
  defn x(_b, q) { putm=put_tiny:; delete_char(:_b, :q) }
  defn zero(_b, q) { sol(:_b, :q) }
  defn dollar(_b, q) { eol(:_b, :q) }

  # undo/redo stuff
  defn u(_b, q) { undo(:_b, :q) }
  defn ctrl_r(_b, q) { redo(:_b, :q) }

  defn dd(_b, q) { putm=put_line:; delete_line(:_b, :q) }
  defn d0(_b, q) { put=put_tiny:; delete_span(:_b, to_sol(:q)); ' delete to start of line ' }
  defn ddollar(_b, q) { putm=put_tiny:; delete_span(:_b, to_eol(:q)); ' delete to end of line ' }
  defn dg(_b, q) { putm=put_tiny:; delete_span(:_b, to_top(:q)); ' delete to top of buffer ' }
  defn dG(_b, q) { putm=put_tiny:; delete_span(:_b, to_bottom(:q)); ' delete to bottom of buffer ' }
  #

  # change stuff
  defn cc(_b, q) { putm=put_tiny:; delete_inner_line(:_b, :q); i(:_b, :q) }
  #
  # insertion/append
  defn i(_b, q) { prints(' insert mode '); getchars() | insert(:_b, :q); ' normal mode ' }
  defn I(_b, q) { sol(:_b, :q); i(:_b, :q) }
  defn a(_b, q) { right(:_b, :q); i(:_b, :q) }
  defn A(_b, q) { eol(:_b, :q); i(:_b, :q) }
  defn o(_b, q) { eol(:_b, :q);  insert("\n", :_b, :q); a(:_b, :q) }

  defn _i_nl(_b, q) { getchars() + "\n" | insert(:_b, :q) }
  defn O(_b, q) { sol(:_b, :q); prints(' open above '); _i_nl(:_b, :q); prints(' normal mode ') }
  defn P(_b, q) { sol(:_b, :q); put(:_b, :q, :putm); line(:_b, :q) }
  #
  # word stuff
  defn F(_b, q) { word(:_b, :q) }
  defn w(_b, q) { word_fwd(:_b, :q) }
  defn dw(_b, q) { delete_word(:_b, :q) }
  defn cw(_b, q) { dw(:_b, :q); i(:_b, :q) }

  # mark stuff
  defn mm(_b, q) { mark(:_b, :q, m:) }
  defn fslash(_b, q) {
    prints(' search ')
    term=read()
    regex(:term) | search(:q)
    n(:_b, :q)
  }
  defn question(_b, q) {
    prints(' reverse search ')
    term=read()
    regex(:term) | search(:q)
    N(:_b, :q)
  }
  defn n(_b, q) {
    next(:q)
    F(:_b, :q)
  }
  defn N(_b, q) {
    prev(:q)
    F(:_b, :q)
  }
  defn colon(_b, q) {
    prints('command')
    read() | commander(:_b, :q) | prints()
    #  L(:_b, :q)
  }
  defn langle(_b, q) {
    outdent(:shift_width, :_b, :q)
    ' line outdented '
  }
  defn rangle(_b, q) {
    indent(:shift_width, :_b, :q)
    ' line indented '
  }
  defn hash(_b, q) { inspect(cursor(:q)) }
  defn caret(_b, q) {
    sol(:_b, :q)
    until({ ! space?(char(:_b, :q))}, { right(:_b, :q) })
    char(:_b, :q)
  }
  defn e(_b, q) {
       until({ space?(char(:_b, :q))}, { right(:_b, :q) })
    left(:_b, :q)
  }
  defn b(_b, q) {
    word_back(:_b, :q)
  }
  defn period(_b, q) { nosave_perf_command(:_b, :q, last_cmd()) }
  # final
  defn ZZ(_b, q) { exit }

  binding()
}






# Main
defn command(b, q) {
  result=getcmd()
count=:result[0]
cmd=:result[1]
perf_command(:b, :q, :count, :cmd)
}
defn nosave_perf_command(b, q, cmd) {
    bind=normal()
fn=:bind[:cmd]
  undefined?(:fn) && { error('key not found'); return ''}
  %fn(:b, :q) | prints()
}

defn perf_command(b, q, count, cmd) {
  bind=normal()
fn=:bind[:cmd]
  undefined?(:fn) && { error('key not found'); return ''}
  # do not save period
  (:cmd != period:) && save_cmd(:cmd)
  times(:count, {%fn(:b, :q)}) | prints()
}

defn go() {
  line(:buf, :q) | prints()
  loop { command(:buf, :q) }
}




# utility stuff
defn key_bound?(fn) {
  x=normal()
  ! undefined?(:x[:fn])
}
defn get_keyfn(name) {
  bind=normal()
  :bind[:name]
}
