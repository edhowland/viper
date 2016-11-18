# reverse - class Reverse - command reverse - reverses stdin lines


class Reverse < BaseCommand
  def call *args, env:, frames:
    input = env[:in].read.each_line.map {|e| e}.reverse.join('')
    env[:out].write input
    true
  end
end
