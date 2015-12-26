# map_key.rb - method map_key maps key (sequence) to sym
def map_key(press, mappings=key_mappings)
  return :space if press == ' '
  result = mappings[press]
  result = ('key_' + press).to_sym if result.nil?
  result
end
