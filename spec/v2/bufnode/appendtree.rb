# appendtree - class Appendtree - command appendtree - adds to end  of buffer
# like instree, but does not add final nl subtree for insertion

class Appendtree
  def call *args, env:, frames:
    root = frames[:vroot]
    wd = root.wd
    node = wd
    until env[:in].eof?
      line = env[:in].gets
      node = node.addnode line
    end
    true
  end
end
