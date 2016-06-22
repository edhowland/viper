# bye - class command Bye - exits out the repl


class Bye
  def call *args, env:, frames:
    exit
  end
end

