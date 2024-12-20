# bin_command.rb: module BinCommand
#
#  BinCommand is rot namespace for Vish classes/commands stored in maybe: /v/bin or /v/viper/bin

module BinCommand
  # These are meant to be commands you might find on some *nix OS. Like cp, mv, ls .etc
  # See also: BinCommand::VFSCommand, BinCommand::ViperCommand
  class NixCommand
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }.reject {|k| k == BaseCommand }
    end
    def self.install_pairs
      descendants.map {|k| [snakeize(k.name), k.new] }
    end
  
  end
end
