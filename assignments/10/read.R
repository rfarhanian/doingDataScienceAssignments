readData <- function() {
  originalData= read.csv(file =  "./NYT1.csv" , header=TRUE, sep=",",fill = TRUE, quote = "\"", skipNul=TRUE, encoding = "UTF-8")
  return (originalData) 
}

cleanData <- function() {
  original= readData()
  #colnames(original)<- c("CountryCode", "Ranking", "", "Country", "GDP", "removeableColumn")
  #gdpData_cleansed <- subset(gdpData_original, select = c("CountryCode", "Ranking", "GDP"),  CountryCode!="" & Ranking!="")
  #gdpData_cleansed$Ranking <- as.numeric(as.character(gdpData_cleansed$Ranking))
  #gdpData_cleansed$GDP <-as.numeric(gsub("[^[:digit:]]","", gdpData_cleansed$GDP))
  #return (gdpData_cleansed)
  return (original)
}

nyt1Data<-cleanData()