# redirection_list - class RedirectionList - handles all created redirects


class RedirectionList
  def initialize list
    @storage = list
  end

  # executes the passed block with outer frames for targets, and frame for passing to block
  def call outer_frames:, frame:, &blk
    files = @storage.map {|r| r.call frames:outer_frames }
    keys = @storage.map {|r| r.type_key }
    env0 = keys.zip(files).to_h
env = {in: $stdin, out: $stdout, err: $stderr}.merge env0
    blk.call env, frame
    @storage.each {|r| r.close }
  end
end
