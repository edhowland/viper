# buffer.vs - class Buffer - holds SlicedBuffer and GridQuery
defn Buffer(b, q) {
  mkattr(b:, :b) + mkattr(q:, :q) +
  ~{j: ->() {
    down(:q)
    sp=line(:q)
    slice(:b, :sp)
  }, k: ->() {
    up(:q)
sp=line(:q)
slice(:b, :sp)
  }, s: ->() {
    sp=line(:q)
slice(:b, :sp)
  }}
}
