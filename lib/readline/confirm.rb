# confirm.rb - method confirm?

def confirm? prompt, default_response='n'
    say prompt
    result = Viper::Readline.new.readline
  return true if result =~ /^[Yy]/
  return false
end
