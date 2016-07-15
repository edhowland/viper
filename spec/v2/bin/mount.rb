# mount - class Mount - command mount /mnt_pt - mounts a VFSRoot in VirtualLayer

class Mount
  def call *args, env:, frames:
    root = VFSRoot.new
    VirtualLayer.set_root root
    root.mkdir_p  args[0]
    root.mount_pt = args[0]
    frames[:vroot] = root
    frames.merge
    true
  end
end
