# sh - class Sh - command sh - runs shell command, mapping stdin, stdout, stderr
# to env[:in, :out, :err]. returning error code  converted into true/false
# rubocop:disable Metrics/AbcSize

class Sh < BaseCommand
  def call(*args, env:, frames:)
    opt = Piped.new(args)


    command = args.join(' ')
    begin
      return_value = nil
      frames[:exit_code] = 0
Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      stdin.write(env[:in].read) if opt.piped?
      stdin.close


      env[:out].write(stdout.read)
      env[:err].write(stderr.read)

  return_value = wait_thr.value
end
    case return_value.exitstatus
    when 0
      return true
    else
      frames[:exit_code] = return_value.exitstatus
      return false
    end 

    rescue => err
      env[:err].puts "exception: #{err.class.name}: #{err.message}"
      false
    ensure
      frames.merge

    end
  end
end
