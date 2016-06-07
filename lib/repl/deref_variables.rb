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
def deref_variables string, variables=Viper::VFS['viper']['variables']
  result = symbol_if_colon(string)
  if result.instance_of?(Symbol)
    Viper::Variables[result]
  else
    string.gsub(/:\{[_\w]+\}|:[_\w]+/) do |match|
      variables[decurly(match).to_sym]
    end
    #result
  end
end
