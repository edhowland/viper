# buffer.vs - class Buffer - holds SlicedBuffer and GridQuery
defn Buffer(b, q, f) {
  mkattr(buf:, :b) + mkattr(qry:, :q) + mkattr(fname:, :f) + 
  ~{j: ->() {
    down(:q)
    sp=line(:q)
    slice(:b, :sp) | prints()
  }, k: ->() {
    up(:q)
sp=line(:q)
    slice(:b, :sp) | prints()

#slice(:b, :sp)
  }, L: ->() {
    sp=line(:q)
slice(:b, :sp) | prints()
  }, Q: ->() {
  prints('exiting')
    exit
  }, y: ->() {
    yank_line(:b, :q)
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
    putreg(:b, :q) | prints()
  }, g: ->() {
    top(:q); sp=line(:q)
slice(:b, :sp) | prints()
  }, G: ->() {
    bottom(:q)
prints('bottom of buffer')
  }, d: ->() {
    delete_line(:b, :q)
prints('one line deleted')
  }, u: ->() {
    undo(:b) | prints()
  }, r: ->() {
    redo(:b) | prints()
  },  f: ->() {
    sp=cursor(:q)
slice(:b, :sp) | prints()
}, i: ->() {
    prints('insert')
sp=cursor(:q)
getchars() | insert(:b, :sp)
    prints(' normal ')
  },  I: ->() {
    prints(' insert before ')
    sp=sol(:q)
getchars() | insert(:b, :sp)
    prints(' normal ')
  }, a: ->() {
    prints(' append ')
sp=right(:q)
getchars() | insert(:b, :sp)
    prints(' normal ')
  },  A: ->() {
    prints(' append after ')
sp=eol(:q)
getchars() | insert(:b, :sp)
    prints(' normal ')
  },o: ->() {
    prints('open line')
    eol(:q); sp=right(:q)
    getchars() + "\n" | insert(:b, :sp)
    prints(' normal ')

    ""
  }, Z: ->() {
    contents(:b) | fwrite(:f)
prints("File :{:f} saved")
exit
  }, m: ->() {
    mark_a(:b, :q)
prints('mark set')
  }, Y: ->() {
    clip_region_a(:b, :q)
    prints('region yanked')
  }, x: ->() {
    sp=delete_char(:b, :q)
    slice(:b, :sp) | prints()
  }}
}
