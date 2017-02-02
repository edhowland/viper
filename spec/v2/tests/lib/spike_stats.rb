# spike_stats.rb - method spike_stats - Spike's final stage: outputs results

def spike_stats
  gru = group {|e| e[0] }
  reduction = reduce([]) {|i, j| i + ["#{j[0]} #{j[1].length}"] }
  ord = {'pass' => -99, 'fail' => -10, 'erro' => 0, 'skip' => 99}
  rearranger = sort { |l, r| ord[l[0..3]] <=> ord[r[0..3]] }

  gru | reduction | rearranger
end
