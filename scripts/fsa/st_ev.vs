# st_ev.vs - fn st_ev(state, evnt) - returns new sym
# st_ev - new symbol by combining two symbols joined with '_'
defn st_ev(st, ev) { mksym(xmit(:st, to_s:) + '_' + xmit(:ev, to_s:)) }

