# sh - class Sh - command sh - runs shell command, mapping stdin, stdout, stderr
# to env[:in, :out, :err]. returning error code  converted into true/false

class Sh < BaseCommand
  def call(*args, env:, frames:)
    opt = nil
    opt = args.shift if args[0] == '-'
    command = args.join(' ')
    begin
      stdin, stdout, stderr = Open3.popen3(command)

      stdin.write(env[:in].read) unless opt.nil?
      stdin.close
      env[:out].write(stdout.read)
      env[:err].write(stderr.read)
    rescue => err
      env[:err].puts "exception: #{err.class.name}: #{err.message}"
      false
    ensure
      stdout.close unless stdout.nil?
      stderr.close unless stderr.nil?
    end
  end
end
