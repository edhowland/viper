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
  }, q: ->() {
  prints('exiting')
    exit
  }, y: ->() {
    sp=line(:q)
slice(:b, :sp) | clip!()
    prints('one line yanked')
}, h: ->() {
    sp=left(:q)
    slice(:b, :sp) | prints()
  }, l: ->() {
    sp=right(:q)
slice(:b, :sp) | prints()
  }, sol: ->() {
    sp=sol(:q)
slice(:b, :sp) | prints()
  }, eol: ->() {
    sp=eol(:q)
slice(:b, :sp) | prints()
  }, unbound: ->() {
    prints('key not bound')
  }, p: ->() {
    eol(:q); sp=right(:q)
    clip() | insert(:b, :sp)
    sp=line(:q)
slice(:b, :sp) | prints()
  }, g: ->() {
    top(:q); sp=line(:q)
slice(:b, :sp) | prints()
  }, G: ->() {
    bottom(:q)
prints('bottom of buffer')
  }, d: ->() {
    sp=line(:q); slice(:b, :sp) | clip!()
delete(:sp, :b)
prints('one line deleted')
  }, u: ->() {
    undo(:b)
prints('undone')
  }, r: ->() {
    redo(:b)
prints('redone')
  }}
}
