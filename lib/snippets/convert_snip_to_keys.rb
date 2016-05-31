# convert_snip_to_keys.rb - method convert_snip_to_keys
# 

 # takes a string of a snippet and converts it to an array of mapped key symbols
def convert_snip_to_keys snip
  mappings = key_mappings.clone
  mappings["\b"] = :back_tab  # fake out \b into back_tab. snips must  use this
  result = snip.chars.map { |e| map_key(e, mappings) }
  result
end
