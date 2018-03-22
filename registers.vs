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
# the tiny register for non lines
_rgt=mkregister()
defn tinyr() { %_rgt[0] }
#
#
# setup for type of put, either put_line or put_tiny
defn put_tiny(b, q) {
  sp=right(:q)
  tinyr() | insert(:b, :sp)
  tinyr()
}
#
defn put_line(b, q) {
  eol(:q); sp=right(:q)
  reg1() | insert(:b, :sp)
  reg1()
}
#
_preg=:put_tiny
defn putreg(b, q) {
  %_preg(:b, :q)
}
#
defn tinyr!(st) { _preg=:put_tiny;  %_rgt[1](:st) }
defn reg1!(st) { _preg=:put_line;  %_rg1[1](:st) }
# yanking
defn yank_line(b, q) {
    sp=line(:q)
slice(:b, :sp) | reg1!()
}
#
defn delete_char(b, q) {
      sp=cursor(:q)
    ch=slice(:b, :sp)
    delete(:sp, :b)
    tinyr!(:ch)
  :sp
}
#
defn delete_line(b, q) {
    sp=line(:q); slice(:b, :sp) | reg1!()
delete(:sp, :b)
}


