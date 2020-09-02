# combine.rb - class Combine - command combine -  outputs args with separator
# Uses :ofs variable as separator
# Note: can be used with ofs=' ' to repeat args, if ever needed

class Combine < BaseCommand
  def call(*args, env:, frames:)
    env[:out].puts args.join(frames[:ofs])
    true
  end
end
