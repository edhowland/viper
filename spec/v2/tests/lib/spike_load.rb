# spike_load.rb  - requires for spike  fns

require_relative 'pipe_proc'
require_relative 'decorated_proc'
require_relative 'assertions'
require_relative 'base_spike'

# spike methods
require_relative 'spike_utils'

require_relative 'spike_generator'
require_relative 'spike_runner'
require_relative 'spike_stats'
require_relative 'spike_color'

def spike_report
  fan_out([spike_stats, (pick(0) | spike_color)])
end