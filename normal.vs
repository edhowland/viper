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
defn d_dollar(b, q) { putm=put_tiny:; delete_span(:b, to_eol(:q)); ' delete to end of line ' }
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
# final
defn ZZ(b, q) { exit }

  binding()
}






# Main
defn command(b, q) {
  cmd=getcmd()
  bind=normal()    # binding()
fn=:bind[:cmd]
  undefined?(:fn) && { error('key not found'); return ''}
  %fn(:b, :q) | prints()
}

defn go() {
  line(:b, :q) | prints()
  loop { command(:b, :q) }
}



