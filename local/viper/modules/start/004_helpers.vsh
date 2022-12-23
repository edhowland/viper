rem helpers.vsh
cmdlet getline '{ pmt=(args.length.zero?? locals[:prompt] : args[0]);  res=get_line(prompt=pmt); out.puts res }'
function rep1(pr) {
  res=:(getline :pr)
  eval ":{res}"
}
