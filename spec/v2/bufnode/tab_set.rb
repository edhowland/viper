# tab_set - class TabSet - command tab_set :_buf - sets tab point at char left
# of current cursor

class TabSet < BaseBufferCommand
  def call *args, env:, frames:
    buf_apply args[0], env:env, frames:frames do |buffer|
      Tab.set(buffer)
    end
  end
end
