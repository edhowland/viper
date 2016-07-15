# buf_writer - class BufWriter - returned by BufWriteFacade


class BufWriter
  def initialize io
    @io = io
  end
  def write string
    enum = string.each_line
    line = @io['line']
    begin
    line.write(enum.next)
    node = @io
      loop do
        node = node.mknode 'nl'
        node['line'].write(enum.next)
      end
    rescue StopIteration
      #
    end
  end
end
