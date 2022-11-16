# rm - class Rm - command rm - rm path - removes file

class Rm < BaseCommand
  def call(*args, env:, frames:)
    if args.empty?
      env[:err].puts 'rm: missing filename'
      return false
    end
    args.each {|f| Hal.rm(f) } 
    true
  end
end
