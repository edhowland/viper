# pwd.rb - command _pwd - prints working directory
# _pwd to differentiate with builtin

def _pwd out:
  out.puts Dir.pwd
end
