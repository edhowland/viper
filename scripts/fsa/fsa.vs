# fsa.vs - functions for finite state automata
#


# newstate(state, fn) - returns fn that runs fn w/world and 
#and returns tuple [result, state] . Expects result to be world
defn newstate(state, fn) { ->(e) { [%fn(:e), :state] } }


#
# mktrans(state, evnet, next, fn) - combines st_ev(:state, :event), new(state(:next, :fn)
defn mktrans(state, event, next, fn) {
  mkpair(st_ev(:state, :event), newstate(:next, :fn))
}


# transit(world, fsa, state, event) - new world and new state from input
defn transit(world, fsa, state, event) {
  y=:fsa[st_ev(:state, :event)]
%y(:world)
}
