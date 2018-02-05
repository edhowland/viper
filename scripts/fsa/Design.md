# Design of the Finite State Automaton

## Abstract:

Use of a FSA is to describe state transitions  between the world, the current state and an envent, such a keypress.

## Rows in the state table:

The table is a Hash. Each key consists of a state_event and the value
is a function that returns a tuple consisting of a world, next_state.

A loop might (see delta.vs) take a world, a state and wait for an event.
This would call transit, calling the function for that state_event combo. given the fetched event.

## Example:

Assume a starting World, and the edit: state.

- Waiting for a keypress
- Decode the key into an event
- Call transit(world, fsa, state, event)
- Now you have [World, State]
- Loop to the Wait part.

Continue until exit: state is returned

An regular printable key might cause the current World to insert it into 
its current buffer.

A Ctontrol-T might switch buffers in the world, and return back to edit:

Meta-D might just return [world, delete_wait:]
Then '[delete_wait:, key_c:] would clear the line and return edit: