# ls - class Ls - Unix-like ls command

class Ls < BaseCommand
  def dir_star(path)
    if Hal.directory?(path)
      "#{path}/*"
    else
      path
    end
  end

  def call(*args, env:, frames:)
    args.unshift '*' if args.empty?
    env[:out].puts Hal[*(args.map { |e| dir_star(e) })]
  end
end
