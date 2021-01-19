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
bike$season <- as.factor(bike$season)

## Exploratory Plots 
ggplot(data=bike, aes(x= hour, y=count, color = as.factor(season))) + 
  geom_point()


## Target encoding (popular one)
bike$hour <- lm(count~hour, data = bike) %>% 
  predict(., newdata = bike %>% select(-count))


bike.model <- train(form = count~hour + holiday + temp,
                    data = bike %>% filter (id =='train'),
                    method = "ranger", 
                    tuneLength = 5,
                    trControl = trainControl(
                      method = "repeatedcv", 
                      number = 10,
                      repeats = 2))


plot(bike.model)
preds <- predict(bike.model, newdata = bike %>% filter(id =="test"))
submission <- data.frame(datetime = bike %>% filter (id =="test") %>% pull(datetime),
                         count = preds)

write.csv(x = submission, file = "./MyThirdSubmission.csv", row.names = FALSE)
