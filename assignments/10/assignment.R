################
# Makefile
# Ramin Farhanian
# Updated 18 July 2017
################

##Setting working directory
cat("Changing working directory.\nCurrent working directory: ", getwd(), "\n")
setwd("/Users/raminfarhanian/projects/R/doingDataScienceAssignments/assignments/10")
cat("working directory is changed to: ", getwd(), "\n")

## Required Libraries
installLibrariesOnDemand <- function (packages)
{
  cat("Installing required libraries on demand:", packages , "\n")
  new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  cat("Missing libraries installation is complete.", "\n")
}
installLibrariesOnDemand(c("repmis", "RCurl","tidyr", "ggplot2"))

##Questions
##1) Download http://stat.columbia.edu/~rachel/datasets/nyt1.csv
cat("Downloading NYT1 file:", "\n")
library(repmis)
library(RCurl)
download.file(url = "http://stat.columbia.edu/~rachel/datasets/nyt1.csv", destfile = "./nyt1.csv")
cat("NYT File is downloaded successfully.", "\n")


## Reading and cleaning NYT1 file
cat("Reading NYT1 file:", "\n")
source("read.R")
cat("NYT1 file is successfully read", "\n")

## 2)	Create a new variable ageGroup that categorizes age into following groups: < 18, 18–24, 25–34, 35–44, 45–54, 55–64 and 65+.
nyt1Data$ageGroup<-cut(nyt1Data$Age, c(-Inf, 18, 24, 34, 44, 54, 64, Inf))
levels(nyt1Data$ageGroup) <- c("<18", "18-24", "25-34", "35-44", "45-54", "55-64", "65+")
cat("ageGroup column is added. Columns are: " , colnames(nyt1Data), "\n")

cat("ageGroup data summary:",(summary(nyt1Data$ageGroup)), "\n")

##3) Use sub set of data called “ImpSub” where Impressions > 0
ImpSub <- subset(nyt1Data, nyt1Data$Impressions>0)

library(ggplot2)
library(scales)
##4 Create a new variable called click-through-rate (CTR = click/impression).
ImpSub$ctr <- ImpSub$Clicks/ImpSub$Impressions

##5 Plot distributions of number impressions and click-through-rate (CTR = click/impression) for the age groups.
plotCtr<- function (data, title) {
  p<-ggplot(data, aes(x=Impressions, fill=ageGroup))+
    geom_histogram(binwidth=1) + ggtitle(title)
  print(p)
}
plotCtr(ImpSub, "click/impression for the age groups")

##6	Define a new variable to segment users based on click -through-rate (CTR) behavior. CTR< 0.2, 0.2<=CTR <0.4, 0.4<= CTR<0.6, 0.6<=CTR<0.8, CTR>0.8
ImpSub$ctrRange <-cut(ImpSub$ctr, c(-Inf, 0.2, 0.4, 0.6, 0.8, Inf), labels = c("CTR< 0.2", "0.2<=CTR <0.4", "0.4<= CTR<0.6", "0.6<=CTR<0.8", "CTR>0.8"))
print(head(ImpSub))

##7	Get the total number of Male, Impressions, Clicks and Signed_In (0=Female, 1=Male)
sums <- sapply(ImpSub[c(2,3,4,5)],sum)
cat("sums:", "\n")
print(sums)

##8 Get the mean of Age, Impressions, Clicks, CTR and percentage of males and signed_In. 
means <- sapply(ImpSub[c("Age", "Impressions","Clicks","ctr")], mean)
cat("8-means:", "\n")
print(means)

percentage <- sapply(ImpSub[c("Gender", "Signed_In")], function(x){sum(x) / NROW(x)})
cat("8-percentage:", "\n")
print(percentage)

##9	Get the means of Impressions, Clicks, CTR and percentage of males and signed_In by AgeGroup.
for(ag in levels(ImpSub$ageGroup) ) {
  current <- ImpSub[which(ImpSub$ageGroup==ag),]
  means <- sapply(current[c("Impressions","Clicks","ctr")], mean)
  cat("means for ageGroup ", ag, " for attributes Impressions, Clicks, ctr are :", means, "\n")
  p <- sapply(current[c("Gender", "Signed_In")], function(x){sum(x) / NROW(x)})
  cat("Percentage of Gender and Signed_In for ageGroup ", ag, " is :", p, "\n")
}

## 10 Create a table of CTRGroup vs AgeGroup counts.
ctrGroupVsAgeGroup<- sapply(ImpSub[c(6,8)], summary)
cat("a table of CTRGroup vs AgeGroup counts:", "\n")
print(ctrGroupVsAgeGroup)


##12 One more plot you think which is important to look at.
plotCtr(ImpSub[which(ImpSub$Gender==1),], "click/impression for different age groups of men") 
plotCtr(ImpSub[which(ImpSub$Gender==0),], "click/impression for different age groups of women")