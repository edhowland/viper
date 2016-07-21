# peek - class Peek - command peek - returns char of LineNode/right


class Peek
  def call *args, env:, frames:
    root = frames[:vroot]
    node = root[args[0]]
    env[:out].print node[0]
    true
  end
end
