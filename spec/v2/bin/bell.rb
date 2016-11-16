# bell - class Bell - command bell - dings tone

class Bell < BaseCommand
  def call *args, env:, frames:
    env[:err].print BELL
  end
end
