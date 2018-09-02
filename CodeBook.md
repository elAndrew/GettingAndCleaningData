Code Book for myTidyData.txt

This dataset contains four unique variables (with headers), and 2,376 observations:

The variable "activity" refers to the activity assoicated with the sensor reading, it has six values:
    WALKING
    WALKING_UPSTAIRS
    WALKING_DOWNSTAIRS
    SITTING
    STANDING
    LAYING
    
The variable "subjectID" identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

The variable "feature" is the list of 66 types of readings that were subsampled from the broader list of 561.  These are the features that were measurements of mean and standard deviations.

The variable "meanValue" is the associated average of each feature, for the activity or subjectID associated with the observation.

This dataset could have met the critera for being "tidy" by being either wide (many variables) or long (many observations with fewer variables).  Either presentation could be correct, and the best choice would be contingent on the type of further analysis being done on the data.  I chose to make a long data set, as I felt the output was the better representation of tidy data.
