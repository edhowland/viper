# lt - class Lte - command lte - returns true if args are less than or equal

class Lte < BaseCommand
  def call *args, env:, frames:
    unless args.length == 2
      env[:err].puts "eq: must supply 2 args. got: #{args.length}. #{args.inspect}"
      false
    else
      args[0].to_i <= args[1].to_i
    end
  end  
end
