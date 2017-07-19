################
# Makefile
# Ramin Farhanian
# Updated 18 July 2017
################

## Introduction to World Bank Study

##Setting working directory
cat("Changing working directory.\nCurrent working directory: ", getwd(), "\n")
setwd("/Users/raminfarhanian/projects/R/doingDataScienceAssignments/assignments/10")
cat("working directory is changed to: ", getwd(), "\n")

## Libraries required

installLibrariesOnDemand <- function (packages)
{
  cat("Installing required libraries on demand:", packages , "\n")
  new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  cat("Missing libraries installation is complete.", "\n")
}
installLibrariesOnDemand(c("repmis", "RCurl", "tidyr", "ggplot2"))

## Part 1: Introduction to the problem

##Questions
# 1)	Create a new variable ageGroup that categorizes age into following groups: < 18, 18–24, 25–34, 35–44, 45–54, 55–64 and 65+.



## Part 2: Downloading required files
## Part 2-1: Downloading FGDP file
cat("Downloading NYT1 file:", "\n")
source("download.R")
cat("NYT File is downloaded successfully.", "\n")


## Part 3: Reading and cleaning NYT1 file
cat("Reading NYT1 file:", "\n")
source("read.R")
cat("NYT1 file is successfully read", "\n")

nyt1Data$ageGroup<-cut(nyt1Data$Age, c(-Inf,18,24,34,44, 54, 64, 65, Inf))
cat("ageGroup column is added. Columns are: " , colnames(nyt1Data), "\n")

cat("ageGroup data summary:",(summary(nyt1Data$ageGroup)), "\n")

nyt1Data <- subset(nyt1Data, nyt1Data$Impressions>0)



