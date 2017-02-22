# buf_reader - class BufReader - recurses down nl s in BufNode, creates string


class BufReader
  def initialize io
    @io = io
  end
  def read
    result = ''
    node = @io
    until node.nil?
      result << node['line'].string
      node = node['nl']
    end
    result
  end
  def close
    # nop
  end
end
