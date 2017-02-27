# jsonify.rb - module Jsonify - addes jsonify method
# encapsulates buffer application adn converting to JSON as well return 
# correct status

module Jsonify
  def jsonify arg, env:, frames:, &blk
    rvalue = buf_apply arg, env:env, frames:frames, &blk
    env[:out].print '{}' unless rvalue
    !rvalue
  end
  # ennumber - returns lambda that increments line number
  # x => [1, x] ... [2, x], [3,x]
  def ennumber
    a = 0
    ->(e) { [a+=1, e] }
  end
end