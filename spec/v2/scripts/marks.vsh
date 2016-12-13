function m(mark) {
  trait_set :_buf :mark
  _mark=:mark; global _mark
}
function mark_first(mark) {
  goto_position :_buf :(trait_first :_buf :mark)
}
function mark_next(mark) {
   goto_position :_buf :(trait_next :_buf :mark)
}
function mark_prev(mark) {
  goto_position :_buf :(trait_prev :_buf :mark)
}
