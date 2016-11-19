# tab_goto - class TabGoto - command tab_goto :_bbuf - advances to next tab pt

class TabGoto < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      Tab.advance(buffer)
    end
  end
end
