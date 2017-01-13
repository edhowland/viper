# vsh_parse.rb - class VshParse - command vsh_parse - get block or syntax error 
# from stdin

class VshParse < BaseCommand
  def call *args, env:, frames:
    source = env[:in].read
      Visher.parse! source
      env[:out].puts 'Syntax OK'
      true
  end
end
