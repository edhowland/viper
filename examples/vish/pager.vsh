rem pager.vsh pages a file like more or less
rem usage vish pager.vsh file.txt
cmdlet pct '{ n,d =*(args.map(&:to_i)); out.puts (n / (d * 1.0) * 100).round }'
load viper
source ":{__DIR__}/pager_keys.vsh"
function floor(num) {
   lte :num 0 && exec { echo 1; return false }
   echo :num
}
function page_back() {
   saved=:(floor :(expr :saved - :(expr 2 '*' :pglines))); global saved
   suppress { goto :_buf  :saved }
   pager
}
alias second="first :(rest :argv)"
file=:(second)
test -X :file || exec { perr There must be one be file to page through; exit }
echo file to page is :file
lines=:(wc -l < :file)
echo line count is :lines
fopen :file
saved=1
pager
loop {
   echo; echo Press space to continue backspace to go back or q to quit. '(' :file ')' :(pct :(line_number :_buf) :lines) '%'
   key=:(raw - | xfkey)
   pg_apply :key
}


