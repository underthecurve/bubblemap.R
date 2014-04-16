setwd("/Users/christinezhang/Desktop")

library(ggplot2)
library(RColorBrewer)
library(grid)
library(WDI)
library(maps)
library(foreign)

results<-WDIsearch("power")
View(results)

data<-WDI(country="all",indicator="EG.USE.ELEC.KH.PC", extra=TRUE)
colnames(data)[colnames(data)=="EG.USE.ELEC.KH.PC"]<-"indicator"
data2011<-subset(data, year==2011 & is.na(indicator)==FALSE & region!="Aggregates")
head(data2011)
data2011<-data2011[c("country","iso3c","indicator","region","income")]

coordinates<-read.csv("Country_List_ISO_3166_Codes_Latitude_Longitude.csv")

data2011_plot<-merge(data2011, coordinates, by.x=c("iso3c"), by.y=c("Alpha.3.code"))

mdat <- map_data('world')
gmap <- ggplot() + geom_polygon(dat=mdat, aes(long, lat, group=group), fill="gray87")+borders("world",colour = "white",size=0.1)

gmap_nolabel <-gmap + geom_point(data=data2011_plot, aes(Longitude..average., Latitude..average., map_id=iso3c, size=indicator, fill=region, alpha=0.75), shape=21, colour="white") + scale_size_area(max_size=30,guide=FALSE)+scale_fill_brewer(palette="Dark2")

#+geom_text(data=data2011_plot,aes(Longitude..average., Latitude..average., label=iso3c, size=300))

# display.brewer.all() gives all color palettes under RColorBrewer

gmap_nolabel

formatted <- gmap_nolabel + theme(axis.line=element_blank(),axis.text.x=element_blank(),axis.text.y=element_blank(),axis.ticks=element_blank(),axis.title.x=element_blank(),axis.title.y=element_blank(),legend.position="none",legend.text=element_text(size=5),legend.key=element_rect(fill=NA),panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),panel.grid.minor=element_blank(),plot.background=element_blank())+guides(alpha=FALSE)

formatted
