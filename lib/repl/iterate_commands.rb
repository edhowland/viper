# iterate_commands.rb - method iterate_commands

def iterate_commands sexps, &blk
  raise CommandBlockExpected.new unless block_given?

  sexps.each do |s|
    cmd, args = s
  exec_cmd cmd, yield, *args
  end
end

