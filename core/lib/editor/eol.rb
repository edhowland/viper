# eol.rb - command eol - goto end of line in buffer

def eol bufpath
  buffer = Viper::VFS.path_to_value bufpath
  buffer.back_of_line
end
 

