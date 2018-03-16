# startup.vs - tie all together
a=getargs()
b=openf(:a[0])
q=mkq(:b)
buf=Buffer(:b, :q)
# read symbol
defn rsym() {
  readc() | sym()
}
# Main loop
%buf.s | prints()
ch='x'
loop {
  (:ch == q:) && break
  ch=rsym()
%buf[:ch] | prints()
}

