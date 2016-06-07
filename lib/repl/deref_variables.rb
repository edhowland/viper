# deref_variables.rb - method deref_variables

# given a string, derefs any variables therein
def deref_variables string
  result = symbol_if_colon(string)
  if result.instance_of?(Symbol)
    Viper::Variables[result]
  else
    result
  end
end
