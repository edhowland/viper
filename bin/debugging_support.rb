# debugging_support.rb: setup stuff for debugging. See ./lib/debugging/*.rb
$vish_trace = false
$vish_debug_log = false
# debug log support
def logd(message)
  if $vish_debug_log
    $stderr.puts message
  else
    # nop 
  end
end
def init_debug(&blk)
  vm = yield
  if $vish_trace
    vm.extend Traceable
     vm.init_trace
  end
  vm
end

def fin_debug(&blk)
  obj = yield
  if $vish_trace &&  obj.respond_to?(:tracing?) && obj.tracing?
    obj.stop_trace
    $stderr.puts("Trace finished")
  $vish_trace = false
  end
  obj
end
if ENV.key?('VISH_TRACE')
  $vish_trace = true
  $stderr.puts("Tracing on")
else
  $vish_trace = false
end


if ENV.key?('VISH_DEBUG_LOG')
  $vish_debug_log = true
  $stderr.puts "VISH_DEBUG_LOG=1"
else
  $vish_debug_log = false
end