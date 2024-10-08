function map_pairs(fn) {
  cond { test -z :_ } { return } else { shift a b; exec :fn :a :b; map_pairs :fn :_ }
}