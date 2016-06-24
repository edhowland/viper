# redirection_list - class RedirectionList - handles all created redirects

# collects and manages any possible redirections.
# This includes any Crossover targets: 2>&1, >&2
class RedirectionList
  def initialize list
    @storage = list || []
    @crossovers = []
  end
  attr_accessor :crossovers
  def perform_crossovers env, redirs_h
    @crossovers.each do|x|
      x.target = redirs_h[x.other_key].handle
      env[x.type_key] = x.target
    end
  end
  # executes the passed block with outer frames for targets, and frame for passing to block
  def call outer_frames:, frame:, &blk
    files = @storage.map {|r| r.call frames:outer_frames }
    keys = @storage.map {|r| r.type_key }
    env0 = keys.zip(files).to_h
env = {in: $stdin, out: $stdout, err: $stderr}.merge env0
redirs_h = @storage.each_with_object({}) {|e, h| h[e.type_key] = e }
perform_crossovers env, redirs_h
    blk.call env, frame
    @storage.each {|r| r.close }
  end
  def to_s
    @storage.map {|r| r.to_s }.join(' ')
  end
end
