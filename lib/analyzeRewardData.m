function stat = analyzeRewardData(data)



stat.Trials = data.Trials(data.Trials(:,11)>0,:);

stat.acc =max(stat.Trials(:,3))/size(stat.Trials,1);

stat.meanAccHigh =  mean(stat.Trials(stat.Trials(:,9) ==1,13));
stat.meanAccLow =  mean(stat.Trials(stat.Trials(:,9) ==0,13));

[a b]=grpstats( stat.Trials(:, 11), [stat.Trials(:,9),  stat.Trials(:,13)], {'mean', 'std'})

stat.highRewardC = stat.Trials(stat.Trials(:,9) ==1 & stat.Trials(:,13) ==1,:);
stat.lowRewardC = stat.Trials(stat.Trials(:,9) ==0 & stat.Trials(:,13) ==1,:);
stat.highRewardI = stat.Trials(stat.Trials(:,9) ==1 & stat.Trials(:,13) ==0,:);
stat.lowRewardI = stat.Trials(stat.Trials(:,9) ==0 & stat.Trials(:,13) ==0,:);

stat.meanHighRewardC = mean(stat.highRewardC(:,11));
stat.stdHighRewardC = std(stat.highRewardC(:,11));
stat.meanLowRewardC = mean(stat.lowRewardC(:,11));
stat.stdLowRewardC = std(stat.lowRewardC(:,11));

stat.meanHighRewardI = mean(stat.highRewardI(:,11));
stat.stdHighRewardI = std(stat.highRewardI(:,11));
stat.meanLowRewardI = mean(stat.lowRewardI(:,11));
stat.stdLowRewardI = std(stat.lowRewardI(:,11));


stat.rewardResult = [stat.meanHighRewardC stat.stdHighRewardC stat.meanLowRewardC stat.stdLowRewardC;...
                     stat.meanHighRewardI stat.stdHighRewardI stat.meanLowRewardI stat.stdLowRewardI;];
                 

boxplot( stat.Trials(:, 11), [stat.Trials(:,9),  stat.Trials(:,13)], 'labels',{'low-incorrect', 'low-correct', 'high-incorrect', 'high-correct'})
hold on;
plot([stat.meanLowRewardI,stat.meanLowRewardC,stat.meanHighRewardI,stat.meanHighRewardC],'d')
hold off;

end