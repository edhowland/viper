# sub_shell_expansion - class SubShellExpansion - :( ...block...) -returns 
# content of the last command's output

class SubShellExpansion < SubShell
  def call env:, frames:
    my_env = env._clone
    sio = StringIO.new
    my_env[:out] = sio
    super env:my_env, frames:frames
      sio.close_write
      sio.rewind
      result = sio.read.gsub(/\n/, ' ').split
      if result.length == 1
        result[0]
      else
        result
      end
  end
  def ordinal
    COMMAND
  end
  def to_s
    ':(' + @block.to_s + ')'
  end
end
