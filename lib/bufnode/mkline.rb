# mkline - class Mkline - command mkline - inserts newline

class Mkline < BaseNodeCommand
  def call(*_args, env:, frames:)
    root = frames[:vroot]
    w = root.wd
    w.newline
    true
  end
end
