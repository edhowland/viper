# plusplus.rb - command plusplus - down one line - '++' in vish

def plusplus bufpath
  buffer = Viper::VFS.path_to_value bufpath
  buffer.down
end

