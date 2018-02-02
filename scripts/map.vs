# map.vs - implements map method over list applying fn for each item, returning
# new list
defn map(li, fn) { 
  (:li == []) && return []
  list(%fn(:li[0]), map(tail(:li), :fn))
}

