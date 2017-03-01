# jsonify.rb - module Jsonify - addes jsonify method
# encapsulates buffer application adn converting to JSON as well return
# correct status

module Jsonify
  def pragma strings, pass_number:''
    r = Regexp.new "%%LINT#{pass_number}"
    !(strings.grep(r).empty?)
  end
  def jsonify arg, pass_name:, env:, frames:, &blk
    buffer = frames[:vroot]["#{arg}/buffer"]
    lines = buffer.lines
    rvalue = yield(lines)
    result = { pass_name => rvalue }.to_json
    env[:out].print result
    # return true if collection is empty, else lint failed with output, false
    rvalue.empty?
  end

  # ennumber - returns lambda that increments line number
  # x => [1, x] ... [2, x], [3,x]
  def ennumber
    a = 0
    ->(e) { [a+=1, e] }
  end
end