rem admin subcommand of charm This is hidden from charm help
wfname=":{lhome}/share/viper/docs/welcome-banner.md"
template=":{wfname}-template"
ifs=":{nl}" ofs=":{nl}" read < :template
b='x="'; a='"'
eval ":{b}:{reply}:{a}"
ifs=" " ofs=" "; global ifs; global ofs
echo -n ":{x}" > :wfname
echo The Viper welcome banner has been updated with version :version


