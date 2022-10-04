# command_let.rb: class CommandLet. Command lets are usually in /v/cmdlet/*

class CommandLet < BaseCommand
  def initialize &blk
    @block = blk
  end
  attr_accessor :block
  def self.from_s(code)
    rcode = self.name + '.new ' + code
    return rcode
  end
  def call(*args, env:, frames:)
    super do
      @block.call
    end
  end
end
