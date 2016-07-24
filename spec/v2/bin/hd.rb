# hd - class Hd - command - converts bytes in stdin to hex, sends to stdout


class Hd
  def call *args, env:, frames:
    env[:out].puts(env[:in].read.bytes.map {|e| "%02x" % e }.join(' '))
  end
end
