# mkrandom.vsh  command let to  get a random  number from 0 to 1023 as a string

# creates a random number from binary input and returns a string from "0" .. "1023"
cmdlet  mkrandom '{ out.puts((inp.read.unpack("I")[0] % 1024).to_s) }'
