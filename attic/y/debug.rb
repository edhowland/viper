# debug - class Debug - command debug - prints out environment

class Debug
  def call *args, env:
    puts "-- debugging --"
    puts "args"
    puts args.inspect
    puts "-- environment --"
    puts env.inspect
  end
end

