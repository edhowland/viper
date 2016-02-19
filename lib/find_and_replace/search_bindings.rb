# search_bindings.rb - method search_bindings - hash of Procs matched to keys in search buffer

def search_bindings
  result = {}
  key_inserter_proc(result, ('a'..'z'))
  key_inserter_proc(result, ('A'..'Z'))
  key_inserter_proc(result, ('0'..'9'))

  result
end

