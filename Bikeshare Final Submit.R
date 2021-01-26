##Libraries I need 
library(tidyverse)
library(DataExplorer)
library(caret)
library(vroom)
library(lubridate)

## Read in the data 
bike.train <- vroom("../Bikesharing/train.csv")
bike.test <- vroom("../Bikesharing/test.csv")
bike <- bind_rows(train = bike.train, test = bike.test, .id = "id")
# combine train and test dataset and then create first column name id (bind_rows :tidyverse)
# use "bike %>% filter(id == "train")" to filter bike.train data

## Drop casual and registered
bike <- bike %>% select(-casual, -registered)

## Feature Engineering 
bike$hour <- hour(bike$datetime) %>% as.factor()
bike$times <- as.POSIXct(strftime(ymd_hms(bike$datetime), format="%H:%M:%S"), format="%H:%M:%S") %>% as.factor()
bike$weekday   <- wday(ymd_hms(bike$datetime), label=TRUE) %>% as.factor()
bike$season <- as.factor(bike$season)
bike$weather <- as.factor(bike$weather)
