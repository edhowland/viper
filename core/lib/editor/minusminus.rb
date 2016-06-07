# minusminus.rb - command minusminus - moves up one line in buffer - '--' in vish

def minusminus bufpath
  buffer = Viper::VFS.path_to_value bufpath
  buffer.up
end

