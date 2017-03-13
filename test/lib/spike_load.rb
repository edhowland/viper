# spike_load.rb  - requires for spike  fns

require_relative 'pipe_proc'
require_relative 'decorated_proc'
require_relative 'assertions'
require_relative 'stub'
require_relative 'mock'


require_relative 'base_spike'

# spike methods
require_relative 'spike_utils'

require_relative 'spike_generator'
require_relative 'spike_runner'
require_relative 'spike_total'

require_relative 'spike_stats'
require_relative 'spike_color'
require_relative 'spike_status'
require_relative 'spike_output'


require_relative 'spike_detail'

# spike_report - last step in chain: formats stats and color
def spike_report
  fan_out([spike_total, spike_stats, spike_detail, (pick(0) | spike_color), (pick(0) | spike_status)])
end

at_exit do 
  run = spike_generate | spike_shuffle | spike_runner | spike_report | spike_output(0..3) | slice(4..4)
  result = run.pump
  exit(result[0])
end

