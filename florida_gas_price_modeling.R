# Matthew J. Keefe
# September 10, 2017
# Predicting Weekly Florida Gas Prices

library(bsts)

#set working directory
setwd("C:/Users/Matthew/Dropbox/Repositories/gas-forecasting")

#read in and format data
FLgas<-read.csv("FLgas.csv",header=FALSE)
names(FLgas)<-c("date","price")
FLgas$date<-as.Date(FLgas$date,format="%Y-%m-%d")

#add regressors to data
FLgas$month <- months(FLgas$date)
FLgas$year <- as.character(format(as.Date(FLgas$date, format="%Y-%m-%d"),"%Y"))
FLgas$week <- strftime(FLgas$date, format = "%V")

#subset down to only 2 years
FLgas <- FLgas[FLgas$date >= '2015-01-01',]

#plot time series of FL gas prices
plot(FLgas$date,FLgas$price,type='l',xlab="Date",ylab="Price per Gallon")

#split data into test and train
numweeks<-30
traindate <- '2016-12-31'
train <- FLgas[FLgas$date <= traindate,]
test <- FLgas[FLgas$date >= traindate,][1:numweeks,]

#try a model
ss <- list()
#ss <- AddLocalLevel(ss, train$price)
ss <- AddLocalLinearTrend(ss, train$price)
# ss <- AddSeasonal(ss, train$price, nseasons = 52) #weeks
# ss <- AddSeasonal(ss, train$price, nseasons = 2) #years
# ss <- AddSeasonal(ss, train$price, nseasons = 12) #months
set.seed(2181)
model <- bsts(price~ month + week, state.specification = ss, niter = 10000, data = train)

#predict for numweeks
model.preds <- predict(model, newdata=test, horizon = nrow(test), burn = 1000)
plot.bsts(model, "components")
plot(model.preds, plot.original = 35, ylim =  c(0,5))
points(x = (nrow(train)+1):(nrow(train)+numweeks), y = test$price , col = "red", pch = 16)

plot.bsts(model, "predictors")
plot.bsts(model, "coefficients")
