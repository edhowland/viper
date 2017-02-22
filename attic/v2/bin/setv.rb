# set - class Setv - command setv var value - sets a variable to some value

class Setv < BaseCommand
  def call *args, env:, frames:
    case args[1]
    when 'true'
      value = true
    when 'false'
      value = false
    else
    value = args[1]
    end
    frames[args[0].to_sym] = value
    frames.merge
    true
  end
end
