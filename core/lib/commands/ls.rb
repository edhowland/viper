# ls.rb - command ls

def ls(*args, out:)
  out.puts(Dir["#{args[0]}/*"])
end
