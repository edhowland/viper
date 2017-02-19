# mkbuf - class Mkbuf - command mkbuf - creates buffer node in VFS

class Mkbuf < BaseNodeCommand
  def call *args, env:, frames:
    root = frames[:vroot]
    if root.nil?
      env[:err].puts "VFS not mounted"
      false
    else
      dnode = root.dirnode args[0]
      base = root.basename args[0]
      dnode[base] = BufNode.new dnode, base
      true
    end
  end
end
