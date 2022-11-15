# mv - class Mv - command mv - mv src dest

class Mv < BaseCommand
  def call(*args, env:, frames:)
    #
    if args.length < 2
      env[:err].puts 'mv: wrong # of arguments.'
      return false
    end
    args[..(-2)].each {|s| Hal.mv(s, args.last) }
    true
  end
end
