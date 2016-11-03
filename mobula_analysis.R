library(kali)
library(animation)

xLat = c(-10,0)
xLon = c(-85,-80)



pesca = subset(pred.mobula, lat=xLat, lon=xLon)

index = 1/apply(pesca$prediction, 3, mean, na.rm=TRUE)

sindex = tapply(index, INDEX = pred.mobula$info$time$month, FUN=mean, na.rm=TRUE)

# plot de area de pesca
plot.map(xlim=xLon, ylim=xLat, hires=TRUE, cex.axis=2)
dev.copy(png, file="Figure3.png", width=1200, height=1200, res=144)
dev.off()

plot(1:12, sindex, type="l", axes = FALSE, 
     ylab="Accesibility index", xlab="Month", las=1)
axis(1, at = 1:12, labels = month.abb)
axis(2)
abline(v=c(8,10), lty=3)
box()
dev.copy(png, file="Figure4.png", width=1200, height=800, res=144)
dev.off()

plot(pred.mobula)
dev.copy(png, file="Figure0.png", width=1200, height=1600, res=144)
dev.off()

plot(pesca, type="climatology")
dev.copy(png, file="Figure5_pesca.png", width=1600, height=1200, res=144)
dev.off()

saveAnimation(pesca, file="mobula_0-2014-2016.gif", dir=output.dir, hires=TRUE)

# Figura bonita de area de estudio, datos
# Figura de area de pesca
# Figura de nicho
# Figura de climatologia
# Figura de estacionalidad del indice
5FA9352D4D2675B9

