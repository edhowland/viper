# hd - class Hd - command - converts bytes in stdin to hex, sends to stdout

class Hd < BaseCommand
  def call(*_args, env:, frames:)
    env[:out].puts(env[:in].read.bytes.map { |e| '%02x' % e }.join(' '))
  end
end
