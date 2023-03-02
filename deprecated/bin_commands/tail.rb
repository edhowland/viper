# tail - class Tail - command tail
# args: -n x
# x: default: 10

class Tail < BaseCommand
  def _count
    result = 10
    result = @av.shift.to_i if @options[:n]
    result
  end

  def call(*args, env:, frames:)
    super do |*_a|
      buffer = @in.read
      lines = buffer.lines
      my_count = [lines.length, _count].min
      start = lines.length - my_count
      lines[start..-1].each { |l| pout l.chomp }
    end
  end
end
