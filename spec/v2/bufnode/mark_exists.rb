# mark_exists - class MarkExists - command mark_exists - true if buffer has mark

class MarkExists < BaseBufferCommand
  def call *args, env:, frames:
    result = false
    buf_apply args[0], env:env, frames:frames do |buffer|
      result = Marker.set? buffer
      ''
    end
    result
  end
end
