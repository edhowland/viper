# tab_exists - class TabExists - command tab_exists :_buf - true if tab point
# exists and absolute position is > current position

class TabExists < BaseBufferCommand
  def call *args, env:, frames:
    result = false
    buf_apply args[0], env:env, frames:frames do |buffer|
      begin 
        result = Tab.set?(buffer) && (Tab.next_abs(buffer) > buffer.position)
      rescue NoTabFound => err
        result = false
      end
    end
    result
  end
end
