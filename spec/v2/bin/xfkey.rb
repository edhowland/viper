# xfkey - class Xfkey - command xfkey - maps bytes to string representsations

class Xfkey
  def call *args, env:, frames:
    values = env[:in].read
    result = {
      "\r" => "return",
      "\e" => "escape",
      " " => "space",
      'A' => 'A'
    }[values]
    unless result.nil?
      env[:out].puts result
    else
      env[:out].puts "unknown"
    end
  end
end

