# 
# Pacific Jack Mackerel niche model (kali package demo)
# Ricardo Oliveros-Ramos (ricardo.oliveros@gmail.com)
# version 15.04.2014
# 

require(kali)
require(animation)
# Input parameters --------------------------------------------------------

auxiliar.prediction.file = "../input/prediction/patita-auxiliar.csv"
output.dir = "output"
species = "mobula"

start   = c(2014,1) # start date of ncdf files
end     = c(2016,9) # end date of ncdf files
lat     = c(-40, 10) # latitude coordinates
lon     = c(-100, -70) # longitude coordinates
dx      = 1/12 # latitude resolution
dy      = 1/12 # longitude resolution

# Pre-processing ----------------------------------------------------------

DateStamp("Starting...")
coords = createGridAxes(lat=lat, lon=lon, dx=dx, dy=dy)
times  = createTimeAxis(start=start, end=end, center=TRUE)

nlat   = length(coords$rho$lat)
nlon   = length(coords$rho$lon)
ntime  = length(times$center)

load(file.path(output.dir, "mobula_model.RData"))

prefix = "patita"

# Predictions -------------------------------------------------------------

DateStamp("Predicting models...")

pred14.16 = setPredictionFiles(prefix=prefix, start=start,
                            end=end, aux=auxiliar.prediction.file, 
                            dir="../input/prediction/")


pred.mobula = predict(mods, pred.info=pred14.16)
save(pred.mobula, file="output/mobula_prediction.RData")

DateStamp("Writing animations...")

saveAnimation(pred.mobula, file="mobula_0-2014-2016.gif", dir=output.dir)
saveAnimation(pred.mobula, file="mobula_1-2014-2016.gif", dir=output.dir, toPA=TRUE)
saveAnimation(pred.mobula, file="mobula_2-2014-2016.gif", dir=output.dir, toPA=TRUE, prob=TRUE)

DateStamp("Saving plots...")

printMaps(pred.mobula, dir=output.dir, prefix="mobula-2014-2016")

DateStamp("Saving image (.RData)")


DateStamp("Finishing...")
