# lt.rb - class Lt - command lt - returns true if args are less than

class Lt < BaseCommand
  def call *args, env:, frames:
    unless args.length == 2
      arg_error 2, env:env
      false
    else
      args[0].to_i < args[1].to_i
    end
  end
end
