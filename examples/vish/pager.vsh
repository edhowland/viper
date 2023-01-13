rem pager.vsh pages a file like more or less
rem usage vish pager.vsh file.txt
load viper
source ":{__DIR__}/pager_keys.vsh"
function floor(num) {
   lte :num 0 && exec { echo 1; return false }
   echo :num
}
function page_back() {
perr in page_back saved is :saved
   saved=:(floor :(expr :saved - :(expr 2 '*' :pglines))); global saved
perr after change saved is now :saved and pglines is :pglines
   suppress { goto :_buf  :saved }
   pager
}
alias second="first :(rest :argv)"
file=:(second)
echo file to page is :file
test -z :file && { perr There must be one be file to page through; exit }
fopen :file
saved=1
pager
loop {
   echo Press space to continue backspace to go back or q to quit
   key=:(raw - | xfkey)
   pg_apply :key
}


