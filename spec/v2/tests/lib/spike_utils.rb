# spike_utils.rb - utilities for spike: spike_flatten, spike_shuffle 

def spike_flatten
  PipeProc.new do |coll|
    coll.flatten
  end
end

def spike_shuffle
  PipeProc.new do |coll|
    coll.shuffle
  end
end


def fan_out fns=[]
  PipeProc.new do |x|
    fns.map {|fn| fn.call_with(x) }
  end
end

def pick ndx
  L {|e| e.map {|c| c[ndx] } }
end