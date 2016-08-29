# head - class Head - command head - outputs x lines of input
# x is default 10, but can be changed with -11, etc.

class Head < BaseCommand
  def _count
    result = 10
    if @options[:n]
      result = @av.shift.to_i
    end
    result
  end
  def call *args, env:, frames:
    super do |*a|
      buffer=@in.read
      buffer.lines[0..(_count - 1)].each {|l| pout l.chomp }      
     end
  end
end
