# cp.rb - class Cp - command cp src dest -

class Cp < BaseCommand
  def call(*args, env:, frames:)
    if args.length <= 1
      env[:err].puts "cp: wrong number of arguments. cp source [.. sources] dest"
      return false
    end
    
    dest, *src = args.reverse
    src.each {|s| Hal.cp(s, dest) }
    true
  rescue Errno::ENOENT => err
      env[:err].puts "cp: No such file or directory. Command was cp #{args.join(' ')}"
      env[:err].puts err.message

  end
end
