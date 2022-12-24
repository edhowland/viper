# rm - class Rm - command rm - rm path - removes file

class Rm < BaseCommand
  def call(*args, env:, frames:)
    if args.empty?
      env[:err].puts 'rm: missing filename'
      return false
    end
  possible = args.map {|f| [Hal.exist?(f), f] }
    bads = possible.reject {|p, f| p }
bads.each {|p, f| env[:err].puts "rm: #{f}: No such file" }

    possible.select {|p, f| p }.each {|p, f| Hal.rm(f) } 
    possible.reduce(false) {|i, j| i || j[0] }
  end
end
