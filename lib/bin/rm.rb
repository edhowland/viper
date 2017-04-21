# rm - class Rm - command rm - rm path - removes file

class Rm < BaseCommand
  def call(*args, env:, frames:)
    if args.empty?
      env[:err].puts 'rm: missing filename'
      return false
    end
    #binding.pry
    Hal.rm args[0]
    true
  end
end
