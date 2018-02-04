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

#plot time series of FL gas prices
plot(FLgas$date,FLgas$price,type='l',xlab="Date",ylab="Price per Gallon")

#split data into test and train
numweeks<-10
train <- FLgas[1:(nrow(FLgas)-(numweeks)),]
test <- FLgas[(nrow(FLgas)-(numweeks-1)):nrow(FLgas),]

#try a model
ss <- list()
#ss <- AddLocalLevel(ss, train$price)
ss <- AddLocalLinearTrend(ss, train$price)
ss <- AddSeasonal(ss, train$price, nseasons = 52)
set.seed(2181)
model <- bsts(price~., state.specification = ss, niter = 10000, data = train)

#predict for numweeks
model.preds <- predict(model, newdata=test, horizon = nrow(test), burn = 1000)
plot.bsts(model, "components")
plot(model.preds, plot.original = 25)
points(x = (nrow(FLgas)-(numweeks-1)):nrow(FLgas), y = test$price , col = "red", pch = 16)
