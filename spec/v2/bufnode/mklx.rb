# mklx - class Mklx - command mklx - adds LineNode to current dir

# TODO: REMOVEME

class Mklx
  def call *args, env:, frames:
    root = frames[:vroot]
    wd = root.wd
    wd['lx'] = LineNode.new wd, 'lx'
    true
  end
end
