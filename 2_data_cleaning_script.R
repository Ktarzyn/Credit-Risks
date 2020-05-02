rm(list = ls())
data <- read.table('original_dataset.csv',header = TRUE, sep = ",")
mylist <-split(data, data$df)
#making two different sets with zeroes and ones
zeroes <- mylist$`0`
ones <- mylist$`1`
zeroframe <- data.frame(zeroes)
oneframe <- data.frame(ones)

library (dgof) 
library(kolmim)
ones1<-rnorm(oneframe$fr) 
zeroes0<-rnorm(zeroframe$fr)
set.seed(0)
ks.test(ones1, zeroes0, alternative="greater")	

library(plyr)
#function to compare different rows from tables to see if their finr and nfinr score is equal
new.compare <- function(first, dataond){
  if (first[1] == dataond[1] && first[2] == dataond[2])
    result <- TRUE
  else
    result <- FALSE
  result
}
#make all data in tables unique and count repeat of each row
counterOne <- count(oneframe, vars = c("finr", "nfinr", "fr", "df"))
counterZero <- count(zeroframe, vars = c("finr", "nfinr", "fr", "df"))
uniqueDfOne <- data.frame(counterOne)
uniqueDfZero <- data.frame(counterZero)
#creating fr data.frame to write data in it
frDf <- data.frame(finr = integer(), nfinr = integer(), fr = integer(), df = integer())
#adding new data in fr dataframe n-times, where n - number of times, data repeats in table
new.add <- function(element, count, frDf){
  for (i in 1:count){
    tmpDf <- data.frame(element[1], element[2], element[3], element[4])
    names(tmpDf) <-c("finr", "nfinr", "fr", "df")
    frDf <- rbind(frDf, tmpDf)
  }
  frDf
}
for (i in 1:nrow(uniqueDfOne)){
  #check to see have we write something or not
  check <- FALSE
  for (j in 1:nrow(uniqueDfZero)){
    #comparing one row from table with df 1 with each from table with zeroes
    if (new.compare(uniqueDfOne[i, ], uniqueDfZero[j, ])){
      #if comparation successfull turn check to true
      check <- TRUE
      #comparing repeating - if df one repeats more than zero, we will write row with df one n-number of times,
      #where n - number of times one repeated in table with df one,
      #and zeroes ignored as anomaly in data
      if (uniqueDfOne[i, 5] > uniqueDfZero[j, 5]){
       frDf <- new.add(uniqueDfOne[i, ], uniqueDfOne[i, 5], frDf)
      } else {
        #doing the same thing as in comment before, but for zeroes
        frDf <- new.add(uniqueDfZero[j, ], uniqueDfZero[j, 5], frDf)
      }
    }
  }
  if (!check){
    #if we do not match our row we will add it to fr data
   frDf <- new.add(uniqueDfOne[i, ], uniqueDfOne[i, 5], frDf)
  }
}
write.csv(frDf, "frDf.csv", row.names = FALSE)
