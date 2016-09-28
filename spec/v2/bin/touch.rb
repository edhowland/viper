# touch - class Touch - command touch file - creates file if non-exist, else 
# updates its time

class Touch < BaseCommand
  def call *args, env:, frames:
    Hal.touch(args[0]) unless args.empty?
    true
  end
end
