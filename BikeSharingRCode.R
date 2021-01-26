##
## Code for Anayzing Bike Sharing Dataset
##


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
bike$season <- as.factor(bike$season)


## Exploratory Plots 
ggplot(data=bike, aes(x= datetime, y=count, color = as.factor(season))) + 
  geom_point()
# by season 

ggplot(data=bike, aes(x= datetime, y=count, color = as.factor(month(datetime)))) + 
  geom_point()
# by month 

plot_missing(bike) #count variable is from the test dataset
plot_correlation(bike, type = "continuous",
                 cor_args = list(use = 'pairwise.complete.obs'))


ggplot(data = bike, aes(x= season, y= count)) +
  geom_boxplot()


## Dummy variable encoding : one-hot encoding 
#(break categorical variable into 1 and 0)
dummyVars(count~season, data = bike, sep = "_") %>%
  predict(bike) %>% as.data.frame() %>%
  bind_cols(bike %>% select(-season), .)


## Target encoding (popular one)
bike$season <- lm(count~season, data = bike) %>% 
  predict(., newdata = bike %>% select(-count))
#table(bike$season) average count for season 


## Fit some models (caret library)
bike.model <- train(form = count~season + holiday + atemp + humidity,
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

write.csv(x = submission, file = "./MyfirstSubmission.csv", row.names = FALSE)




