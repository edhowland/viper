# sol.rb - command sol - start of line for a buffer

def sol bufpath
  buffer = Viper::VFS.path_to_value bufpath
  buffer.front_of_line
end

