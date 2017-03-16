# not - class Not - command not expression - inverts truth of expression

class Not < Exec
  def call *args, env:, frames:
    super
    !frames[:exit_status]
  end
end
