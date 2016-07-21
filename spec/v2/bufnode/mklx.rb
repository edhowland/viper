# mklx - class Mklx - command mklx - adds LineNode to current dir

# TODO: REMOVEME

class Mklx
  def call *args, env:, frames:
    root = frames[:vroot]
    wd = root.wd
    node = LineNode.new wd, 'lx'
    node.left = args[0]
    node.right = args[1] unless args.length < 1
    wd['lx'] = node
    true
  end
end
