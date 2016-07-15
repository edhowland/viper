# ls - class Ls - Unix-like ls command


class Ls
  def call *args, env:, frames:
#binding.pry
    args = Hal['*'] if args.empty?
    args.each do |f|
      list = [f]
      list += Dir["#{f}/*"] if Hal.directory? f
      list.each { |e| env[:out].puts e }
    end
  end
end