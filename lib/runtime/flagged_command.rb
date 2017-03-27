# flagged_command.rb - class  FlaggedCommand - base for commands that take
# dashed args
# rubocop:disable Style/DoubleNegation

# %%LINT4
# Example usage:
# class Flag < FlaggedCommand
# def initialize
# super(flags: {'-e' => false, '-f' => ''}) do |inp, out, err, frames, flags, *args|
# out.puts 'in flag:'
# out.puts "-e #{flags['-e'].to_s}"
# out.puts "-f #{flags['-f']}"
# out.puts "remaining args"
# out.puts args.inspect
# true
# end
# end
# end

class FlaggedCommand < BaseCommand
  def initialize(flags: {}, &blk)
    super()
    @parser = FlagHash.new flag_hash: flags
    @block = blk
  end

  def call(*args, env:, frames:)
    flags, remains = @parser.parse!(args)
    result = @block.call env[:in], env[:out], env[:err], frames, flags, *remains
    !!result
  end
end
