# mv - class Mv - command mv - mv src dest

class Mv < BaseCommand
  def call(*args, env:, frames:)
    src, dest = args
    if src.nil? || dest.nil?
      env[:err].puts 'mv: wrong # of arguments. mv src dest'
      return false
    end
    Hal.mv src, dest
    true
  end
end
