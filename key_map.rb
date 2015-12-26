# key_map.rb - method key_map maps key (sequence) to sym
def map_key(press, mappings=key_mappings)
  result = mappings[press]
  result || press
end
