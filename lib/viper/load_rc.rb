# load_rc.rb - method load_rc conditionally loads .viperrc-type files and yields to each line

def load_rc(path = "~/.viperrc", opts = {}, &blk)
  expanded_path = File.expand_path(path)
  begin
    File.open(expanded_path, 'r').each_line(&blk)
  rescue => err
    unless opts[:silent]
      say "Could not process #{path} Response was\n"
      say err.message
    end
  end
end
