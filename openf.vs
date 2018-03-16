# openf.vs - open file into GridQuery
defn openf(fname) {
  fread(:fname) | mkbuffer()
}
defn mkq(buff) {
  mkquery(:buff)
}
# create an object
defn Newbuf(buf, qry) {
  mkattr(buf:, :buf) + mkattr(q:, :qry)
}
# cursor methods



