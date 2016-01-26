# check_ruby_syntax.rb - method  check_ruby_syntax

def check_ruby_syntax(buffer)
  output, error = shell(RUBY_SYNTAX) do |input|
    input.write(buffer.to_s)
  end

  say output
  say error
end
