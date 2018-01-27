# Matthew J. Keefe
# September 10, 2017
# Predicting Weekly Florida Gas Prices

#set working directory
setwd("C:/Users/Matthew/Dropbox/Matts Stuff/Florida Gas Prices")

#read in and format data
FLgas<-read.csv("FLgas.csv",header=FALSE)
names(FLgas)<-c("date","price")
FLgas$date<-as.Date(FLgas$date,format="%Y-%m-%d")

#plot time series of FL gas prices
plot(FLgas$date,FLgas$price,type='l',xlab="Date",ylab="Price per Gallon")


