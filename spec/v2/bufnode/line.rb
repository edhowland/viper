# line - class Line - command line to buffer

class Line < BaseBufferCommand
  def call *args, env:, frames:
        buf_apply(args[0], env:env, frames:frames) do |buffer|
      @meth0.call buffer
    end
  end
end

