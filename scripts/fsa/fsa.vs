# fsa.vs - functions for finite state automata
#
# st_ev - new symbol by combining two symbols joined with '_'
defn st_ev(st, ev) { mksym(xmit(:st, to_s:) + '_' + xmit(:ev, to_s:)) }


# newstate(state, fn) - returns fn that runs fn w/world and 
#and returns tuple [result, state] . Expects result to be world
defn newstate(state, fn) { ->(e) { [%fn(:e), :state] } }


#
# mktrans(state, evnet, next, fn) - combines st_ev(:state, :event), new(state(:next, :fn)
defn mktrans(state, event, next, fn) {
  mkpair(st_ev(:state, :event), newstate(:next, :fn))
}

