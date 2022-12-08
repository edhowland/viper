# raise - class Raise - command raise message string - raises RuntimeError
# with passed message. This will be stored in global :last_exception
class Raise < BaseCommand
  def call(*args, env:, frames:)
    message = args.join(' ')
    frames.first[:last_exception] = message
    frames.first[:exit_status] = false
    raise VishRuntimeError.new(message)
  end
end
