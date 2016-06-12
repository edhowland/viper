# command - class Command - wraps a silly command - anything that responds to :call

class Command
  def initialize command
    @command = command
  end
  def call *args, env:{}
    env[:out].puts "#{@command} called  with:"
    env[:out].puts args.inspect
    puts "environment:"
p env
    puts '---'
    true
  end
end
