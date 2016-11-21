# vish - class Vsh - command vsh "string of commands" - runs Vish parser,vm on 
# string


class Vsh < BaseCommand
  def call *args, env:, frames:
    code = args.join(' ')
    vm = frames.vm
      cblock = Visher.parse! code
      result = vm.call cblock
    result
  end
end
