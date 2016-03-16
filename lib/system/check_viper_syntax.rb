# check_viper_syntax.rb - method check_viper_syntax.rb

def check_viper_syntax(buffer)
  begin
    result = true
    syntax_ok?(buffer)
  rescue => err
    result = false
    say err.message
  end
  if result
    say "Syntax OK\n"
  else
    say "\nSyntax check failed"
  end
  result
end
