# digest_sha1 - class DigestSha1 - command digest_sha1 -  - returns computed SHA
# in hexadecimal format.
# args :
# -c number - clips off the first number chars. Defaults to entire string
# -f fpath : Use fpath as file path to compute digest

# by default, output base64 encode. Results in shorter output  strings w/entropy

require 'digest/sha1'

class DigestSha1 < BaseValueCommand
  def base64 digester, length=-1, string=nil
    digester.base64digest(string)[0..length]
  end
  def digest
    result = Digest::SHA1
    @options[:f] ? result.file(@options[:f]) : result
  end

  def clip_length
    @options[:c] || -1
  end

  def gets
  unless @options[:f]
    @ios[:in].read
  end
  end

  def call *args, env:, frames:
    super do |*a|
    arg_to_i :c
      env[:out].write(base64(digest, clip_length, gets))
    end
    true
    end
  end
