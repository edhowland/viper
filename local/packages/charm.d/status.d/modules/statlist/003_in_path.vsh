rem Are we in the users path
cond { in_path } { echo Your Viper and Vish  and ivsh and charm  commands are already in your PATH } else { cat ":{pdir}/path.md" }
