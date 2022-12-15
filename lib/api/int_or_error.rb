# int_or_error.rb : function int_or_error
# If passed an Integer, returns it. identy function
# if passed string : '0', converts it to zero
# any other case returns 255 as a integer

def int_or_error(code)
  if code.instance_of?(String)
    return 255 if /[0-9]{1,3}/.match(code).nil?
  end
  code = code.to_i
  code
end