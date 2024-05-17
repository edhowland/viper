# vfs_command.rb: class BinCommand::VFSCommand
# Parent of all BaseNodeCommand. Commands not directly related to buffer commands
# which come under BinCommand::ViperCommand

class BinCommand::VFSCommand
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }.reject {|k| k == BaseNodeCommand }
    end
  def self.install_pairs
    descendants.map {|k| [snakeize(k.name), k.new] }
  end
  def args_parse!(args)
    @options = {}
    args.select { |e| e =~ /^\-.+/ }
        .map { |e| e[1..-1].to_sym }
        .each { |e| @options[e] = true }
    args.reject { |e| e =~ /^\-.+/ }
  end
end

