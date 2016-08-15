# perr - class Perr - command perr - redirects stdin to stderr - debugging use

class Perr
  def call *args, env:, frames:
    env[:err].write(env[:in].read)
    true
  end
end

