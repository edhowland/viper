# normal.vs - get and process viper cmd for normal mode
#
# the current put method
putm=put_tiny:
# putm=put_line:

defn normal() {
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
  defn yquote_m(b, q) { putm=put_tiny:; yank_region(:b, :q, region_of(:b, :q, m:)) }
  defn y0(b, q) { putm=put_tiny:; yank_region(:b, :q, to_sol(:q)); ' yanked to fron of line ' }
  defn ydollar(b, q) { putm=put_tiny:;  yank_region(:b, :q, to_eol(:q)); ' yanked to end of line ' }
  defn dquote_m(b, q) { putm=put_tiny:; delete_region(:b, :q, region_of(:b, :q, m:)) }
  defn p(b, q) { put(:b, :q, :putm) }
  defn x(b, q) { putm=put_tiny:; delete_char(:b, :q) }
  defn zero(b, q) { sol(:b, :q) }
  defn dollar(b, q) { eol(:b, :q) }

  # undo/redo stuff
  defn u(b, q) { undo(:b, :q) }
  defn ctrl_r(b, q) { redo(:b, :q) }

  defn dd(b, q) { putm=put_line:; delete_line(:b, :q) }
  defn d0(b, q) { put=put_tiny:; delete_span(:b, to_sol(:q)); ' delete to start of line ' }
  defn ddollar(b, q) { putm=put_tiny:; delete_span(:b, to_eol(:q)); ' delete to end of line ' }
  defn dg(b, q) { putm=put_tiny:; delete_span(:b, to_top(:q)); ' delete to top of buffer ' }
  defn dG(b, q) { putm=put_tiny:; delete_span(:b, to_bottom(:q)); ' delete to bottom of buffer ' }
  #

  # change stuff
  defn cc(b, q) { putm=put_tiny:; delete_inner_line(:b, :q); i(:b, :q) }
  #
  # insertion/append
  defn i(b, q) { prints(' insert mode '); getchars() | insert(:b, :q); ' normal mode ' }
  defn I(b, q) { sol(:b, :q); i(:b, :q) }
  defn a(b, q) { right(:b, :q); i(:b, :q) }
  defn A(b, q) { eol(:b, :q); i(:b, :q) }
  defn o(b, q) { eol(:b, :q);  insert("\n", :b, :q); a(:b, :q) }

  defn _i_nl(b, q) { getchars() + "\n" | insert(:b, :q) }
  defn O(b, q) { sol(:b, :q); prints(' open above '); _i_nl(:b, :q); prints(' normal mode ') }
  defn P(b, q) { sol(:b, :q); put(:b, :q, :putm); line(:b, :q) }
  #
  # word stuff
  defn F(b, q) { word(:b, :q) }
  defn w(b, q) { word_fwd(:b, :q) }
  defn dw(b, q) { delete_word(:b, :q) }
  defn cw(b, q) { dw(:b, :q); i(:b, :q) }

  # mark stuff
  defn mm(b, q) { mark(:b, :q, m:) }
  defn fslash(b, q) {
    prints(' search ')
    term=read()
    regex(:term) | search(:q)
    n(:b, :q)
  }
  defn question(b, q) {
    prints(' reverse search ')
    term=read()
    regex(:term) | search(:q)
    N(:b, :q)
  }
  defn n(b, q) {
    next(:q)
    F(:b, :q)
  }
  defn N(b, q) {
    prev(:q)
    F(:b, :q)
  }
  defn colon(b, q) {
    prints('command')
    read() | commander(:b, :q) | prints()
    #  L(:b, :q)
  }
  defn langle(b, q) {
    outdent(:shift_width, :b, :q)
    ' line outdented '
  }
  defn rangle(b, q) {
    indent(:shift_width, :b, :q)
    ' line indented '
  }
  defn hash(b, q) { inspect(cursor(:q)) }
  defn period(b, q) { nosave_perf_command(:b, :q, last_cmd()) }
  # final
  defn ZZ(b, q) { exit }

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
  line(:b, :q) | prints()
  loop { command(:b, :q) }
}



