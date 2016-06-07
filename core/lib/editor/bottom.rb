# bottom.rb - command bottom - moves to end of buffer

def bottom bufpath
  buffer = Viper::VFS.path_to_value bufpath
  buffer.fin
end

