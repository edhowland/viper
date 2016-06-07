# deref_variables.rb - methods deref_variables, decurlry

# extracts foo from :{foo}
def decurly bracelet
  m=bracelet.match /:\{([_\w]+)\}|:([_\w]+)/
  if m.nil?
    '_not_found'
  else
  m.captures.reject {|e| e.nil? }.first
end
end

# given a string, derefs any variables therein
def deref_variables string
  result = symbol_if_colon(string)
  if result.instance_of?(Symbol)
    Viper::Variables[result]
  else
    #occurs = string.scan /:\{[_\w]+\}/
    #expansions = occurs.map { |e| sym = decurly(e).to_sym;[sym, Viper::VFS["viper"]["variables"][sym]] }.to_h
    string.gsub(/:\{[_\w]+\}|:[_\w]+/) do |match|
      Viper::VFS['viper']['variables'][decurly(match).to_sym]
    end
    #result
  end
end
