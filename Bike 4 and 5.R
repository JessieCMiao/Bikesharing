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
bike$times <- as.POSIXct(strftime(ymd_hms(bike$datetime), format="%H:%M:%S"), format="%H:%M:%S")
bike$season <- as.factor(bike$season)


## Exploratory Plots 
ggplot(data=bike, aes(x= times, y=count, color = as.factor(season))) + 
  geom_point()


## Target encoding (popular one)
bike$times <- lm(count~times, data = bike) %>% 
  predict(., newdata = bike %>% select(-count))


bike.model <- train(form = count~ times + holiday + temp,
                    data = bike %>% filter (id =='train'),
                    method = "rf", #regression of the assumption
                    tuneLength = 5, #how its evaulating prediction
                    trControl = trainControl(
                      method = "boot", 
                      number = 10, #how many sample
                      repeats = 2)) 


plot(bike.model)
preds <- predict(bike.model, newdata = bike %>% filter(id =="test"))
submission <- data.frame(datetime = bike %>% filter (id =="test") %>% pull(datetime),
                         count = preds)

write.csv(x = submission, file = "./MyFifthSubmission.csv", row.names = FALSE)
