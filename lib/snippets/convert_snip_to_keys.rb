# convert_snip_to_keys.rb - method convert_snip_to_keys
# 

# converts \n into \r so map_key does the right thing

 def slash_n2r key
  (key == "\n" ? "\r" : key)
end

 # takes a string of a snippet and converts it to an array of mapped key symbols
def convert_snip_to_keys snip
  mappings = key_mappings.clone
  mappings["\b"] = :back_tab  # fake out \b into back_tab. snips must  use this
  result = snip.chars.map { |e| map_key(slash_n2r(e), mappings) }
  result
end
