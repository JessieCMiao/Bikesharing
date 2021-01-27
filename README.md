# Bikesharing

a.	What is the overall purpose of this project?

The purpose of this project is to forecast bike rental demand in the Capital Bike share program in Washington, D.C. by combine historical usage patterns with weather data from 2011 to 2012. 

b.	What do each file in your repository do?

test.csv and train.csv are the dataset from the Kaggle competition (https://www.kaggle.com/c/bike-sharing-demand/overview). BikeSharingRcode.R include what Professor Heaton did in class to help us start off this competition. Bikesharing-SelfCode.R is my best submission for this Kaggle competition which received a score of 0.66538. 

c.	What methods did you use to clean the data or do feature engineering?

I first remove variables "casual"(number of non-registered user rentals initiated) and "registered"(number of registered user rentals initiate) since they are not relevant for predicting bike rent count. Next, I evaluated which variables were factors and transformed them accordingly. Using the datetime variable, I feature engineered the variables "hour" and "time". Then, I change season variable as factor. After doing some EDA, I notice that distribution of counts is skewed left. So, I took the log to normalize the response variable. 


d.	What methods did you use to generate predictions?

I decided to use ranger random forest method in order to predict the model. And set tuning parameter grid to 5. Then I attempted 20 cross validations for each group of settings. I used this model to make our predictions which were then exponentiated to the original scale.


