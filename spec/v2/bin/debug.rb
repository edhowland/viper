# debug - class Debug - command debug - prints out environment

class Debug
  def call *args, env:, frames:
    puts "-- debugging --"
    puts "args"
    puts args.inspect
    puts "-- environment --"
    puts env.inspect
    puts "variables frames --"
    puts frames.inspect
  end
end

