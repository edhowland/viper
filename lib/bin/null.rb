# null.rb - class Null - for when no command in Statement

class Null < BaseCommand
  def call(env:, frames:)
    frames.merge
    frames[:exit_status]
  end
end
