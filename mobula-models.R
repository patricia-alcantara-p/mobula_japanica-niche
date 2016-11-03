# mobula niche model
# Ricardo Oliveros-Ramos (ricardo.oliveros@gmail.com)
# version 28.01.2016
require(mgcv)
require(kali)
source("auxiliar_functions.R")
   
# Input parameters --------------------------------------------------------

inputFile = "input/base_mobula_pa-mobula_1985_2015.csv"
outputPath = "output"
batchName = "mobula_global"

ratio = 0.2 # fraction of data used for validation
species = "mobula"
link = "logit"
factors = "masas"
# Pre-processing ----------------------------------------------------------

DateStamp("Starting...")

if(!exists("global")) {
  global = read.csv(inputFile)
  global[, species] = as.factor(global[,species])
  for(var in factors) global[, var] = as.factor(global[, var])
} 

# Training and validation -------------------------------------------------

DateStamp("Creating training and validation datasets")

global.model = splitDataSet(global,  species, factor=ratio)

test = global
test$lchl = log10(test$chl)
test$loxi = log10(test$oxip)
# Train models ------------------------------------------------------------

neg = test[test$mobula==0,]

DateStamp("Training models...")


fmlas = list()
fmlas$mod0 = as.formula("mobula ~ s(sst,k=3) + s(chl,k=3)")
fmlas$mod1 = as.formula("mobula ~ s(sst) + s(chl)")
fmlas$mod2 = as.formula("mobula ~ s(sst,k=6) + s(chl,k=6)")
fmlas$mod3 = as.formula("mobula ~ s(sst, chl)")
fmlas$mod4 = as.formula("mobula ~ te(sst, chl)")

mods = fitGAMs(global.model, fmlas)

save(mods, file=file.path("output", "mobula_model.RData"))


# mod0 = gam(mobula ~ s(sst,k=k) + s(chl,k=k), data=test, family=binomial(link=link))

plot.new()
plot.window(xlim=range(test$sst), ylim=range(test$chl))
points(chl ~ sst, data=test, subset=test$mobula==1, col="blue", pch=19, cex=0.5)
points(chl ~ sst, data=test, subset=test$mobula==0, col="red", pch=4, cex=0.5)
axis(1)
axis(2)
box()

n0 = calculateNiche(mods$models$mod0, req.sens = 0.9)
n1 = calculateNiche(mods$models$mod1, req.sens = 0.9)
n2 = calculateNiche(mods$models$mod2, req.sens = 0.9)
n3 = calculateNiche(mods$models$mod3, req.sens = 0.9)
n4 = calculateNiche(mods$models$mod4, req.sens = 0.9)

plot(n0, vars = c("sst", "chl"))
plot(n1, vars = c("sst", "chl"))
plot(n2, vars = c("sst", "chl"))
plot(n3, vars = c("sst", "chl"))
plot(n4, vars = c("sst", "chl"))

x11()

layout(matrix(c(1,4,3,2), ncol=2), widths=c(4,1), heights=c(1,4))
par(mar=c(0,0,0,0), oma=4*c(1,1,0.5,0.5))
density(n4, var="sst", axes=FALSE, col=c("blue", "red"), lwd=c(2,2))
legend("topright", legend = c("Presences", "All data"), 
       col=c("blue", "red"), lty = c(1,1), cex = 1, bty = "n")
density(n4, var="chl", vertical=TRUE, axes=FALSE, col=c("blue", "red"), lwd=c(2,2))
plot.new() # skip one plot

plot(n4, vars = c("sst", "chl"), type="hull", )
points(n4, vars = c("sst", "chl"), col="blue", pch=19)
points(chl ~ sst, data=neg, col="red", pch=4, cex=0.75)
legend("topleft", legend = c("Presences", "Absences"),
       col = c("blue", "red"), pch=c(19, 4), cex = 1, bty = "n")
mtext(text = "Sea Surface Temperature (ºC)", side = 1, cex = 1, line = 2.5)
mtext(text = "Chlorphyll-a concentration (mg/L)", side = 2, cex = 1, line = 2.5)

dev.copy(png, file="Figure1.png", width=1200, height=1200, res=144)
dev.off()
