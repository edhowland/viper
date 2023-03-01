rem cap.vsh cmdlet version of capture
cmdlet cap '{ nop=Visher.parse!("nop"); args.push(*[nop,nop]); p, x, f = args; invoke(p); locals.merge; }'
  
