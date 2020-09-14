library(readr)
library(ggplot2)
library(viridisLite)

## Import Data ##
alldata <- read_csv("Documents/paired-soil-sensors/alldata.csv", 
                    col_types = cols(`Date and Time` = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                     `Depth (cm)` = col_character()))
## Timeseries Plot ##
startdate = as.POSIXct("2018-06-01",tz="UTC")
enddate = as.POSIXct("2018-09-01", tz="UTC")
# ggplot(data = alldata[alldata$Hyprop==FALSE & alldata$`Date and Time`>startdate & alldata$`Date and Time`<enddate,],
#        mapping = aes(x = `Date and Time`, color=`Texture`)) +
#   geom_line(mapping=aes(y=`Water Content`), size=0.5) +
#   geom_line(mapping=aes(y=`Water Potential (kPa)`/5000 + 0.3), size=0.5, alpha=0.5) +
#   facet_wrap(vars(Site,`Depth (cm)`), nrow=2) +
#   scale_y_continuous(sec.axis = sec_axis(trans=~(.-.3)*5000, name = "Water Potential (kPa)",)) +
#   coord_cartesian(ylim = c(0,0.3))

## Charts in SWCC style for each soil type, each sensor pair has one color. Add Hyprop data.
ggplot() +
  geom_point(mapping = aes(x = abs(`Water Potential (kPa)`), y = `Water Content`, color=`Texture`),
            data = alldata[alldata$Hyprop==FALSE,],
            alpha = 0.1,
            size = 0) +
  geom_line(mapping = aes(x = abs(`Water Potential (kPa)`), y = `Water Content`, color=`Texture`),
            data = alldata[alldata$Hyprop==TRUE,],
            alpha = 1,
            size = 1) +
  facet_wrap(vars(Site, `Depth (cm)`), nrow = 2) +
  coord_cartesian(xlim = c(0,500)) +
  xlab('Water Potential (-kPa)')

## Bonus points: find best fit Van Genuchten curves, using SWRCFit. 