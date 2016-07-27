# xfkey - class Xfkey - command xfkey - maps bytes to string representsations

class Xfkey
  def call *args, env:, frames:
    values = env[:in].read
    if ('A'..'Z').include?(values) || ('a'..'z').include?(values)
      env[:out].write values 
      return true
    end
    result = {
      "\r" => "return",
      "\e" => "escape",
      " " => "space",
      'A' => 'A'
    }[values]
    unless result.nil?
      env[:out].write result
      true
    else
      env[:out].write "unknown"
      false

    end
  end
end

