# Viper editor main startup
argv=getargs()
tup=openf(:argv[0])
buf=:tup[0]
q=:tup[1]
file_name=:tup[2]
norm=normal()
# Start me up
go()


