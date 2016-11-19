# mark - class Mark - command mark
# sets mark on buffer character @ current position

class Mark < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      Marker.set buffer
    end
  end
end
