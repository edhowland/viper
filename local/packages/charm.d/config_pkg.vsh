rem config subcommand of charm
import charmutils
pdir=":{__DIR__}/config.d"
eq 3 ":{argc}" || exec { perr charm config missing subcommand; exit 1 }
lpath=":{__DIR__}/config.d" load :(third :argv)
