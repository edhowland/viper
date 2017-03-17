# perr - class Perr - command perr - redirects stdin to stderr - debugging use

class Perr < BaseCommand
  def call(*args, env:, frames:)
    super do |*a|
      meth = (@options[:n] ? :print : :puts)
      if a.empty?
        @err.send(meth, @in.read)
      else
        @err.send(meth, a.join(' '))
      end
    end

    true
  end
end
