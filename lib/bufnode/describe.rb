# describe - class Describe - command describe - echos string version of
# VFS node

class Describe < BaseNodeCommand
  def call *args, env:, frames:
    super do |*a|
      r=frames[:vroot]
      node = r[a[0]]
      string = node.to_s
      pout "#{string}"
    end
  end
end
