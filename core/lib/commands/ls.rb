# ls.rb - command ls

def ls(*args, out:)
  out.puts(Viper::VFS.resolve_path(args[0]))
end
