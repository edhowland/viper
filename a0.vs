# a0.vs - first test of stuff

defn file_txt(file) {
  fread(:file) | mkbuf()
}

# some settings
shift_width=2
args=getargs()
file_name=:args[1]
b=file_txt(:args[1])
q=mkquery(:b)
# utility functions
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
defn undefined?(o) {
  :o == 'undefined'
}


