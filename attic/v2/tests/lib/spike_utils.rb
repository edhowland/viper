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
def group &blk
  L do |coll|
    coll.group_by &blk
  end
end

def reduce init, &blk
  L do |coll|
    coll.reduce(init, &blk)
  end
end

def map &blk
  L do |coll|
    coll.map &blk
  end
end

def ident
  L do |coll|
    coll
  end
end
def fan_in
  reduce([]) {|i,j| i + j }
end

def sort &blk
  L do |coll|
    coll.sort &blk
  end
end

def reverse
  L do |coll|
    coll.reverse
  end
end
def rotate
  L do |coll|
    coll.rotate
  end
end
def filter &blk
  L do |coll|
    coll.select &blk
  end
end

def slice range=(0..-1)
  L do |coll|
    coll.slice(range)
  end
end
