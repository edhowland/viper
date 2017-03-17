# touch - class Touch - command touch file - creates file if non-exist, else
# updates its time

class Touch < BaseCommand
  def call *args, env:, frames:
    args.each {|f| Hal.touch(f)}
    true
  end
end
