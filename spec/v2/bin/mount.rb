# mount - class Mount - command mount /mnt_pt - mounts a VFSRoot in VirtualLayer

class Mount
  def call *args, env:, frames:
    root = VFSRoot.new
    VirtualLayer.set_root root
    root.mkdir_p  args[0]
    true
  end
end
