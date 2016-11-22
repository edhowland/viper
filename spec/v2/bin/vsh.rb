# vish - class Vsh - command vsh "string of commands" - runs Vish parser,vm on 
# string

class Vsh < BaseCommand
  def normalize_status status
    status = (status.nil? ? true : status)
    status = (status.empty? ? true : status)
  status
  end
  def call *args, env:, frames:
    code = args.join(' ').chomp
            frames[:exit_status] = normalize_status(frames[:vsh_status])
      return frames[:vsh_status] if code.empty?    
      block = Visher.parse! code

    result = block.call env:env, frames:frames
    frames[:vsh_status] = result
    frames.merge
    result
  end
end
