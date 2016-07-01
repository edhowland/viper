# ls - class Ls - Unix-like ls command


class Ls
  def call *args, env:, frames:
    args = Dir['*'] if args.empty?
    args.each do |f|
      list = [f]
      list += Dir["#{f}/*"].map {|e| "#{f}/#{e}" } if File.directory? f
      list.each { |e| env[:out].puts e }
    end
  end
end
