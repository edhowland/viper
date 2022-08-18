# shuffle.rb - class Shuffle - command shuffle list - takes list, outputs 
# shuffled list

class Shuffle < BaseCommand
  def call *args, env:, frames:
    env[:out].puts args.shuffle.join(' ')
    true
  end
end
