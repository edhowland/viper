# startup.vs - tie all together
a=getargs()
b=openf(:a[0])
q=mkq(:b)
buf=Buffer(:b, :q)
# Main loop
%buf.s | prints()
ch='x'
loop {
  :ch == 'q' && break
  ch=readc()
  sm=sym(:ch)
%buf[:sm] | prints()
}

