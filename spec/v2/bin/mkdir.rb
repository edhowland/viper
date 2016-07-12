# mkdir - class Mkdir - command mkdir - works like  mkdir -p /path/to/dir



class Mkdir
  def call *args, env:, frames:
    Hal.mkdir_p args[0]
  end
end
