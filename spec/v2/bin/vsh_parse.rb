# vsh_parse.rb - class VshParse - command vsh_parse - get block or syntax error 
# from stdin

class VshParse < BaseCommand
  def call *args, env:, frames:
    source = env[:in].read
    block = Visher.parse! source
    if args.length > 0
      frames[args[0].to_sym] = block
      frames.merge
    else
      env[:out].puts 'Syntax OK'
    end
    true
  end
end
