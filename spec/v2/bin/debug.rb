# debug - class Debug - command debug - prints out environment

class Debug < BaseCommand
  def print_args args
    puts "args"
    args.each {|e| puts e.inspect }
  end
  def call *args, env:, frames:
    puts "-- debugging --"
    print_args args
    return true
    puts "-- environment --"
    puts env.inspect
    puts "variables frames --"
    puts frames.inspect
  end
end

