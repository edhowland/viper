# viper_command.rb: class BinCommand::ViperCommand - Base for BaseBufferCommand

class BinCommand::ViperCommand
  def initialize
        @options = {}
  end
  attr_reader :options

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }.reject {|k| k == BaseBufferCommand }
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
