# check_viper_syntax.rb - method check_viper_syntax.rb
def check_viper_syntax(buffer)
  result = syntax_ok?(buffer)
  if result
    say 'Syntax OK'
  else
    say 'Syntax check failed'
  end
  result
end
