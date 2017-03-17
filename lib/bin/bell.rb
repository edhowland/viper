# bell - class Bell - command bell - dings tone

class Bell < BaseCommand
  def call(*_args, env:, frames:)
    env[:err].print BELL
    true
  end
end
