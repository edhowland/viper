# redirectable - module Redirectable - included in Statement, SubShell

module Redirectable
  def redirectable?(object)
    object.ordinal == REDIR
  end

  def redirect(object, env:, frames:)
    object.call env: env, frames: frames
  end

  # open_redirs: open streams, returning values for closers
  def open_redirs(env:)
    env.top.each_pair { |k, v| env[k] = v.open }
    env.values
  end

  # close_redirs : closes objects opened above
  def close_redirs(closers)
    closers.each(&:close)
  end
end
