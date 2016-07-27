# grep - class Grep - command grep - looks for regex in lines


class Grep
  def regex_line node, &blk
    line = node['line']
    yield line.string
  end
  def call *args, env:, frames:
  root = frames[:vroot]
  node = root.wd
  result = nil
  until node.nil?
    result = regex_line(node) {|s| s.index /2/ }
    break unless result.nil?
    node = node['nl']
  end
  unless result.nil?
    line = node['line']
    env[:out].puts line.string 
    root.wd = node
      true
    else
      false
  end
  end
end
