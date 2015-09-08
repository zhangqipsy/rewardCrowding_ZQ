### rewardCrowding is the name of the project.

### rewardedLearning is the main program;

### loadDefaultConfs is where we specify numbers; all other places are codes; it returns conf and mode.

 - conf is the configurations/settings for the experiment.
 - mode changes certain behavior of the program. For example, mode.english_on changes the language into
english, while if false turns into Chinese.

### genSequence uses the conf and mode variables to generate the experiment sequence, namely data.Trials

The sequence controls all the data that are used for the stimuli generation and presentation. 
This is the file where ALMOST ALL random number generation takes place; anywhere else should NOT 
generate random numbers.

### getTime is the database for experiment timing. This is the only place that generates random numbers except genSequence

### genRewardData uses the sequence to construct data which could then be directly plotted/flipped on the screen, namely data.draw

### drawObjects draws all the objects defined in data.draw on the screen automatically

### Test file is where everything starts
