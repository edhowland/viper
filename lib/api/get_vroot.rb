# get_vroot.rb : method get_vroot : safely returns the $vm.fs[:vroot]

def get_vroot
  return nil if $vm == nil
  res = $vm.fs[:vroot]
  return nil if res.kind_of?(String) && res.empty?
  res
end