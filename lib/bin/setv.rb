# set - class Setv - command setv var value - sets a variable to some value

class Setv < BaseCommand
  def call(*args, env:, frames:)
    value = case args[1]
            when 'true'
              true
            when 'false'
              false
            else
              args[1]
            end
    frames[args[0].to_sym] = value
    frames.merge
    true
  end
end
