# alias.rb - command alias - sets alias

def format_alias name, out:
  value = Viper::VFS['viper']['alias'][name]
  fail "alias: #{name} not found" if value.nil?
  out.write("alias #{name} \"#{value}\"\n")
end

# sets, prints an alias or prints all aliases
def _alias name, string, out:
  if name.nil?
    Viper::VFS['viper']['alias'].keys.each {|e|format_alias e, out:out } 
  elsif string.nil?
    format_alias name, out:out
  else
    Viper::VFS["viper"]["alias"][name] = string
  end
end
