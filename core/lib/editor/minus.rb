# minus.rb - command minus - moves one character back - '-' in vish

def minus bufpath
  buffer = Viper::VFS.path_to_value bufpath
  buffer.back
end

