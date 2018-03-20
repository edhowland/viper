# marks.vs - functions for setting/resolving marks
defn pos(sp) {
  xmit(:sp, first:)
}
defn mark_a(b, q) {
  sp=cursor(:q)
  p=pos(:sp)
xmit(:b, set_mark:, a:, :p)
}
defn region_a(b, q) {
  p=pos(cursor(:q))
  xmit(:b, region_of:, a:, :p)
}
defn clip_region_a(b, q) {
  sp=region_a(:b, :q)
  slice(:b, :sp) | clip!()
}

