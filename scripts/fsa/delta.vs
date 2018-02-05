# delta.vs - given the world, change it.
defn delta(world, fsa, state) {
  loop {
    key=readc()
event=decode(:key)
    world_state=transit(:world, :fsa, :state, :event)
    (:world_state[1] == exit:) && break
  }
  :world
}
