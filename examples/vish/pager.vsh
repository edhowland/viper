rem pager.vsh pages a file like more or less
echo pager.vsh starting up
rem usage vish pager.vsh file.txt
load viper
file=:(first :(rest  :argv))
echo file to page is :file
test -z :file && { perr There must be one be file to page through; exit }
fopen :file
pager
loop {
   echo Press space to continue or q to quit
   key=:(raw - | xfkey)
   cond { eq :key key_q || eq :key ctrl_q } { exit } { eq :key key_space } { pager } else { perr no such command :key }
}


