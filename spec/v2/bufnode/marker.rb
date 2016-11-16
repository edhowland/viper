# mark - class Marker - command markerer

class Marker < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      Mark.set buffer
    end
  end
end
