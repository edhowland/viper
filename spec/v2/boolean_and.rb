# boolean_and - class BooleanA - implements && operatornd



class BooleanAnd
  def initialize left, right
    @left  = left
    @right = right
  end
  def call env:, frames:
    @left.call(env:env, frames:frames) && @right.call(env:env, frames:frames)
  end
end
