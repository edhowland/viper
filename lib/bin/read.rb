# read - class Read - command read - stdin is split and stored into vars
# Like the read command in Bash

class Read < BaseCommand
  def call *args, env:, frames:
    vars = env[:in].gets.chomp.split(' ')
    combine = args.map {|e| e.to_sym }.zip vars
    combine.each do |e|
      frames[e[0]] = e[1]
    end
    frames.merge
    true
  end
end
