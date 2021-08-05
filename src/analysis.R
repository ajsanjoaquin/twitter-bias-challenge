# Loading in data
dataMain <- read.csv("C:/Users/Golam Rabbani/Downloads/twitter-20210804T043131Z-001/twitter/resultsClean.csv", stringsAsFactors = FALSE, header = TRUE)

# Calculating proportion of images that meet each criteria over each category
dataObservation <- aggregate(dataMain[,3:5], by=list(dataMain$ï..Category), mean)

# Calculating proportion of overall unwanted croppings
dataCombined <- data.frame(Category=dataMain[,1], Is_Unwanted=(rowSums(dataMain[,3:5])>0))
dataSummary <- aggregate(dataCombined[,2], by=list(dataCombined$Category), mean)