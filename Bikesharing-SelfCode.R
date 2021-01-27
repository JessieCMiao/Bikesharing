##Libraries I need 
library(tidyverse)
library(DataExplorer)
library(caret)
library(vroom)
library(lubridate)
library(ggplot2)

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
bike$log_count <- log10(bike$count)


## Exploratory Plots 
ggplot(data=bike, aes(x= times, y=count, color = as.factor(season))) + 
  geom_point()
ggplot(bike) + 
  geom_histogram(mapping = aes(x=count), bins= 30,
                 fill = 'gray', col = 'black') ##dist of count
ggplot(data=bike, aes(x= hour, y=count, color = as.factor(season))) + 
  geom_point()


## Target encoding (popular one)
bike$times <- lm(log_count~times, data = bike) %>% 
  predict(., newdata = bike %>% select(-count))
bike$hour <- lm(log_count~hour, data = bike) %>% 
  predict(., newdata = bike %>% select(-count))


bike.model <- train(form = log_count~ times + hour + holiday + temp,
                    data = bike %>% filter (id =='train'),
                    method = "ranger", #regression of the assumption
                    tuneLength = 5, #how its evaulating prediction
                    trControl = trainControl(
                      method = "repeatedcv", 
                      number = 10, 
                      repeats = 2))#how many sample
                    



plot(bike.model)
preds <- predict(bike.model, newdata = bike %>% filter(id =="test"))
submission <- data.frame(datetime = bike %>% filter (id =="test") %>% pull(datetime),
                         count = 10^preds) #change back log_count

write.csv(x = submission, file = "./MyFifthSubmission.csv", row.names = FALSE)
