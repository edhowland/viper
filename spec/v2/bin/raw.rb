# raw - class Raw,  - command raw - reads one char from $stdin into var


class Raw
  def call *args, env:, frames:
    frames[args[0].to_sym] = $stdin.getch
    frames.merge
    true
  end
end
