# spike_stats.rb - method spike_stats - Spike's final stage: outputs results

def spike_stats
  PipeProc.new do |coll|
    e = coll.group_by {|x| x[0] }.to_enum
    stats = e.map do |s|
      [s[0], s[1..-1].length]
    end
    stats.unshift [:total, stats.length]
    stats.map {|l| "#{l[1]} #{l[0]}" }
  end
end
