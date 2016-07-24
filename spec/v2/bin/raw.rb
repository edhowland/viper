# raw - class Raw,  - command raw - reads one char from $stdin into var


class Raw
  def call *args, env:, frames:
    if args[0] == '-'
      env[:out].write $stdin.getch
    else
      frames[args[0].to_sym] = $stdin.getch
      frames.merge
    end
    true
  end
end
