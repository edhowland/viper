# spike_detail.rb - method spike_detail - reports detail of :fail, :error

def spike_detail
  filter {|e| e[0] == :fail || e[0] == :error || e[0] == :skip }
end
