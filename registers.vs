# registers.vs - handles all clipboard/register functions
defn mkclip() {
  cl=""
  [->() { :cl }, ->(s) { cl=:s }]
}
x=mkclip()
cl=:x[0]
cls=:x[1]
defn clip!(s) { %cls(:s) }
defn clip() { %cl }




# registers
defn mkregister() {
  rg1=''
  [->() { :rg1 }, ->(st) { rg1=:st }]
}
_rg1=mkregister()
defn reg1() { %_rg1[0] }
defn reg1!(st) { %_rg1[1](:st) }
# the tiny register for non lines
_rgt=mkregister()
defn tinyr() { %_rgt[0] }
defn tinyr!(st) { %_rgt[1](:st) }
