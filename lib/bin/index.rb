# index.rb - class Index - command index array offset. value of array[offset]
# reported to stdout



class Index < BaseCommand
  def call *args, env:, frames:
    env[:out].puts args[0][args[1].to_i]
  end
end