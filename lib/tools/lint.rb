# lint.rb - method lint - performs passes on buffer

def lint(buffer)
  
  send "check_ruby_lint".to_sym, buffer
end
