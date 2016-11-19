# cut - class Cut - command cut - extracts text from buffer, sends to stdout

class Cut < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      env[:out].write(Marker.cut(buffer))
      ''
    end
  end
end
