# nop - class Nop - No operation command

class Nop < BaseCommand
  def call(*args, env:, frames:)
  true
  end
end
