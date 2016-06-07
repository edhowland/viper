# top.rb - command top - moves to beginning of buffer

def top bufpath
  buffer = Viper::VFS.path_to_value bufpath
  buffer.beg
end

