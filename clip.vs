# cl.vs
defn mkclip() {
  cl=""
  [->() { :cl }, ->(s) { cl=:s }]
}
x=mkclip()
cl=:x[0]
cls=:x[1]
defn clip!(s) { %cls(:s) }
defn clip() { %cl }



