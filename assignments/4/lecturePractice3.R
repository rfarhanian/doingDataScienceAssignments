
download.file(url = "https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/datasets/LakeHuron.csv", destfile = "./LakeHuron.csv")

cat("Date of file download:",format(file.info("./LakeHuron.csv")$ctime, format="%Y-%m-%d %H:%M:%S"), "\n")

originalData= read.csv(file =  "./LakeHuron.csv" , header=TRUE, sep=",", fill = TRUE, quote = "\"", skipNul=TRUE, encoding = "UTF-8")

cat("Dimensions of the data:", dim(originalData), "\n")

cat("Variable names for the file:", colnames(originalData), "\n")

cat("Variable types for the variables in the file:", str(originalData), "\n")



