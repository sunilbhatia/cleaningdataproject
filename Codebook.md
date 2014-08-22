## Data assumptions
  * Data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
  * Data collected from the accelerometers from the Samsung Galaxy S smartphone.
    - 6 Activities 
    - 561 Features
    - 30 Subjects
  * Activities & Features(Measurements)
    - **activity_labels.txt** contains the 6 Activities
    - **features.txt** constains the 561 Features and their descriptions
  * Test data
    - **test/subject_test.txt** contains the table with the subjects
    - **test/X_test.txt** containts the table with the features
    - **test/y_test.txt** containts the table with the activities
  * Traint data
    - **train/subject_train.txt** contains the table with the subjects
    - **train/X_train.txt** containts the table with the features
    - **train/y_train.txt** containts the table with the activities

## Project Analysis Steps
#### Step 0 -  Prepare the project environment
  * Set the project working directory
  * Install and Load the plyr and reshape packages if they have not been loaded
  * Download the data if it has not been downloaded

#### Step 1 - Merges the training and the test datasets to create one data set. 
  * Read the **activity_labels.txt** so that the the merged dataset columns can be named
  
  * Read the subject column from **test/subject_test.txt** 
  * Read the activity column from **test/y_test.txt** 
  * Read the feature columns from **test/y_test.txt**
  * **Combine the test dataset - subject, activity, and features using cbind()**
  
  * Read the subject column from **train/subject_train.txt** 
  * Read the activity column from **train/y_train.txt** 
  * Read the feacture columns from **train/y_train.txt**
  * **Combine the train dataset - subject, activity, and features using cbind()**
  
  * <font color='green'>Merge the test and train datasets by subject using a full join so that the missing rows in test and train datasets can be added to the table. The *plyr package join_all()* function was used to accomplish this.</font>
  
#### Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
  * Extract the mean and std columns from **activity_labels.txt** feature name column using a regular expression
  * Add the Subject and Activity column to the list
  * <font color='green'>Subset the 81 columns in the list from the merged dataset in step1. Now we have only the 81 coumns we need.</font>
  
#### Step 3 - Uses descriptive activity names to name the activities in the data set
  * Follow the variable naming conventions from the class to rename the feature variables
  * <font color='green'>Take the 81 existing column names, remove parenthesis, dashes(-), and CamelCase the names</font>

#### Step 4 - Appropriately labels the data set with descriptive variable names.
  * <font color='green'>Use the vector of CamelCase variables from Step 3 and use colnames(data) to rename the data column names.</font>
  
#### Step 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
  * <font color='green'>Create data.frame with mean from every Feature Variable(79 columns) using the **aggregate(features, by(Subject, Activity), mean)**
  * Melt the data.frame using  **melt(means, by(Subject,Activity), features)** to create a long table instead of wide table - this makes documenting the table easier.</font>
  * Order data by(Subject, Activity)
  * <font color='green'>Write the data to **tidy_data.txt**
  * The final tidy dataset has four variables (Subject, Activity, MeasuredVariable, MeasuredVariableMean). I chose the long form as the final result as it is easier to read and to document.</font>
  
## Tidy Dataset description
  * The resulting tidy dataset is stored in **tidy_data.txt**
  * It is stored in a comma-delimited file with four columns(Subject, Activity, MeasuredVariable, MeasuredVariableMean)
    - **Subject**: The subject numeric value - One of 30 subjects being studied
    - **Activity**: The activity numeric value - One of six activities being studied
    - **MeasuredVariable**: The name of feature variable - One of 79 features being studied
    - **MeasuredVariableMean**: The average of every feature - 79 features in the original data, represented as a numeric value.
  * Each row in the tidy data is a permutation of(Subject, Activity, Feature), followed by the Feature Average
  * <font color='green'>Since there are 30 Subjects, 6 Activities, and 79 Feature Variables, the final tidy dataset should have **4 columns, and 14220 rows**.</font>









  
  
  
  
