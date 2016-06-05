# touch.rb -  command touch

# _touch creates a new node in directory if it doesn't exist, else does nothing
# _touch to distinguish from touch in pry, others
def _touch path
  return unless Viper::VFS.path_to_value(path).nil?
  Viper::VFS.mknode path
end

