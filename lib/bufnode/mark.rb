# mark.rb - class Mark - command mark :_buf - sets mark at current char in buf

class Mark < BaseBufferCommand
  def call(*args, env:, frames:)
    buf_apply args[0], env: env, frames: frames do |buffer|
      Marker.set buffer
      ''
    end
  end
end
