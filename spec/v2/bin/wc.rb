# wc - class Wc - command wc - like the bash one
# possible future args:
# -c [default] : prints the character count of the stdin
# -w : prints the word count of the stdin
# -l prints the line count of stdin


class Wc
  def call *args, env:, frames:
    env[:out].puts env[:in].read.length
    true
  end
end
