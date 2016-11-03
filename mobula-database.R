require(kali)
source("auxiliar_functions.R")

lat = c(-40, 10); lon = c(-100, -70)

# Reading datasets --------------------------------------------------------

DateStamp("Reading databases")
# presence/absence
mobula = read.csv("input/mobula_japanica_envPA.csv")

# Cleaning datasets -------------------------------------------------------

DateStamp("Cleaning databases")

# remove mobula==NA

# removing duplicates
names(mobula) = tolower(names(mobula))

index = c("lon", "lat", "year", "month", "day")
vars  = c("sst", "chl", "sss")
aux   = c("dc", "prof", "shelf")
full.vars = c(index, vars, aux, "mobula")
main.vars = c("sst", "chl", "mobula")
min.vars = c("sst", "chl")

# correct oxiP
mobula$oxip[mobula$year<1992] = NA

mobula   = mobula[complete.cases(mobula[, main.vars]),]

# Refine databases --------------------------------------------------------

DateStamp("Refining databases")

mobulaP    = mobula[mobula$mobula==1, ] # use all distribution range

mobx = mobula
mobula   = clearAbsences(data=mobula, control=mobula, species="mobula", vars=min.vars)

DateStamp("Balancing prevalence")

pseudo = mobula[mobula$mobula==0,]
mobula   = balancePA(mobula, pseudo, "mobula")
mobx   = balancePA(mobx, pseudo, "mobula")

n.mobula = countMap(mobula, "mobula", lat, lon, dx=1/6, dy=1/6)
dev.copy(png, filename="output/data_count_mobula_estadios.png"); dev.off()

mobula[, "mobula"]   = toPA(mobula[, "mobula"])
mobx[, "mobula"]   = toPA(mobx[, "mobula"])

# trim coordinates
mobula = trimCoords(mobula)
mobx = trimCoords(mobx)

# Sort by time ------------------------------------------------------------

mobula = sortByTime(mobula)
mobx = sortByTime(mobx)

DateStamp("Writing new datasets")

write.csv(mobula, "input/base_mobula_pa-mobula_1985_2015.csv", row.names=FALSE)
write.csv(mobx, "input/base_mobula_pa-mobulax_1985_2015.csv", row.names=FALSE)

