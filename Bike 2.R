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
bike$month <- month(bike$datetime) %>% as.factor()
bike$weather <- as.factor(bike$weather)


## Exploratory Plots 
ggplot(data=bike, aes(x= datetime, y=count, color = as.factor(weather))) + 
  geom_point()

ggplot(data = bike, aes(x= weather, y= count)) +
  geom_boxplot()


## Dummy variable encoding : one-hot encoding 
dummyVars(count~weather, data = bike, sep = "_") %>%
  predict(bike) %>% as.data.frame() %>%
  bind_cols(bike %>% select(-weather), .)

## Target encoding (popular one)
bike$weather <- lm(count~weather, data = bike) %>% 
  predict(., newdata = bike %>% select(-count))


## Fit some models (caret library)
bike.model <- train(form = count~weather + holiday + humidity + windspeed,
                    data = bike %>% filter (id =='train'),
                    method = "rf", 
                    tuneLength = 5,
                    trControl = trainControl(
                      method = "oob", 
                      number = 10))

plot(bike.model)
preds <- predict(bike.model, newdata = bike %>% filter(id =="test"))
submission <- data.frame(datetime = bike %>% filter (id =="test") %>% pull(datetime),
                         count = preds)

write.csv(x = submission, file = "./MySecondSubmission.csv", row.names = FALSE)
