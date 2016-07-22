# buf_writer - class BufWriter - returned by BufWriteFacade


class BufWriter
  def initialize io
    @io = io
  end
  def write string
    enum = string.each_line
    line = @io['line']
    begin
    line.right = enum.next
    node = @io
      loop do
        node = node.mknode 'nl'
        node['line'].right = enum.next
      end
    rescue StopIteration
      #
    end
  end
  def puts string
    string = string.chomp
    write string + "\n"
  end
  def close
    # nop
  end
end
