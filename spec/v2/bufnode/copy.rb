# copy - class Copy - command copy - copies marked text to _clip: clipboard

class Copy < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      env[:out].write(Mark.copy(buffer))
      ''
    end
  end
end
