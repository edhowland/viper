# plus.rb - command plus - increments buffer by one character -  '+' in vish

def plus bufpath
  buffer = Viper::VFS.path_to_value bufpath
  buffer.fwd
end

