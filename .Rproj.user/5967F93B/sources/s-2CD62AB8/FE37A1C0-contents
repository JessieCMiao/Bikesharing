# Bikesharing

a.	What is the overall purpose of this project?
THe purpose of this project is to forecast bike rental demand in the Capital Bike share program in Washington, D.C. by combine historical usage patterns with weather data from 2011 to 2012. 

b.	What do each file in your repository do?

c.	What methods did you use to clean the data or do feature engineering?

d.	What methods did you use to generate predictions?


The first markdown file represents the my best submission for this Kaggle competition which received a score of 0.70540. It outlines which packages I used, how I went about cleaning the data, what exploratory and feature analysis I performed, how I fit the model, and finally some code at the end preparing the data for submission to Kaggle. The second .R file in this repository was a test file to indicate that my coding software had attached to Github successfully. This .R file was not used in the Kaggle competition.

WHAT METHODS DID YOU USE TO CLEAN THE DATA OR DO FEATURE ENGINEERING?

First, I eliminated the provided variables "casual" and "registered" because they did not appear in both the test and train datasets provided by Kaggle. Next, I evaluated which variables were factors and transformed them accordingly. Using the datetime variable, I feature engineered the variables "year", "month", "hour", "weekday", and "daytime". Not all of these variables were included in the final model ("weekday" and "daytime were excluded). Finally, I attempted to normalize the response variable using the log1p() function which took the logarithm of my count variable +1.

WHAT METHODS DID YOU USE TO GENERATE PREDICTIONS?

I used the ranger random forest method in order to make our model. After playing around with a few settings, I found that node size was irrelevant so I set it equal to 1, split rule was set to "variance" for a slightly smaller prediction error, and finally the optimal number of variables to split at each node was 5. We attempted 20 cross validations for each group of settings. We used this model to make our predictions which were then transformed out of the logarithmic scale to their original scale before submission.