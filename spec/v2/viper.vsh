function mode.keys() { 
for i in :_ {
key=:(echo -n :i | xfkey)
bind :key &() { echo -n :i | push line/left } &() { echo -n :i } 
}
}
uc=A..Z lc=a..z nu=0..9 pu1='!..\' pu2=':..@' pu3='[..`' pu4='{..~'
_mode=viper mode.keys :lc :uc :nu :pu1 :pu2 :pu3 :pu4
