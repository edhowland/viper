rem admin subcommand of charm This is hidden from charm help
wfname=":{lhome}/share/viper/docs/welcome-banner.md"
template=":{wfname}-template"
cat :template | ifs=":{nl}" ofs=":{nl}" read welcome
b='x="'; a='"'
eval ":{b}:{welcome}:{a}"
echo -n ":{x}" > :wfname

