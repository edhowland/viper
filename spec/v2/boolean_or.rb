# boolean_or - class BooleanOr- implements || operator

class BooleanOr
  def initialize left, right
    @left = left
    @right = right
  end
  def call env:, frames:
    @left.call(env:env, frames:frames) || @right.call(env:env, frames:frames)
  end
end


