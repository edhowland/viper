# unset_mark - class UnsetMark - command unset_mark :_buf - unsets any mark in buf


class UnsetMark < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      Marker.unset buffer
      ''
    end
  end
end
