# a1.vs - first test of stuff
# w/o getargs stuff

defn file_txt(file) {
  fread(:file) | mkbuf()
}
defn openf(fname) {
  b=file_txt(:fname)
  q=mkquery(:b)
  [:b, :q]
}
# some settings
shift_width=2
# utility functions
defn until(e, blk) {
  %e && return ''
  %blk
  until(:e, :blk)
}
defn times(count, fn) {
  (:count < 2) && return %fn
  %fn
  times(:count - 1, :fn)
}


defn _times(count, fn) {
result=''
  loop {
    zero?(:count) && return :result
count=:count - 1
    result=%fn
print(:result)
  }
}


