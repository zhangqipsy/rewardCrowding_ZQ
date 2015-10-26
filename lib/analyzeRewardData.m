function stat = analyzeRewardData(data)

columnTest = 11; % reaction time
columnCond1 = 9; % 1 for high reward 0 for low reward
columnCond2 = 13; % 1 for correct 0 for incorrect

stat.allTrialNum = size(data.Trials,1);
stat.Trials = data.Trials(data.Trials(:,columnTest)>0,:);% no NaN

stat.miss = 1-size(stat.Trials,1)/stat.allTrialNum; %the persentage of miss trials

stat.accAll =max(stat.Trials(:,3))/size(stat.Trials,1);% acc for all trial with keypress
stat.accHigh =  mean(stat.Trials(stat.Trials(:,columnCond1) ==1,columnCond2));% acc for high reward trials
stat.accLow =  mean(stat.Trials(stat.Trials(:,columnCond1) ==0,columnCond2));% acc for low reward trials

[stat.meansd(:,1) stat.meansd(:,2)] = grpstats( stat.Trials(:, columnTest), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], {'mean', 'std'});
% the sequence is 00-low reward incorrect 01-low reward correct 
%                 10-high reward incorrec 11-high reward correct
stat.Result = [stat.meansd(4,1),stat.meansd(2,1),stat.meansd(4,2),stat.meansd(2,2)];% only correct trials

f =figure('visible','off');
subplot(2,2,1);
plot(stat.Trials(stat.Trials(:,columnCond1) ==0 & stat.Trials(:,columnCond2) ==1,columnTest));
title('low reward');
subplot(2,2,2);
plot(stat.Trials(stat.Trials(:,columnCond1) ==1 & stat.Trials(:,columnCond2) ==1,columnTest));
title('high reward');
subplot(2,2,3);
boxplot( stat.Trials(:, columnTest), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], 'labels',{'l-inco', 'l-co', 'h-inco', 'h-co'});
hold on;
plot(stat.meansd(:,1),'d');
hold off;
subplot(2,2,4)
alpha = 0.05;
[stat.M,stat.CI,stat.N,stat.G] = grpstats(stat.Trials(stat.Trials(:,columnCond2) ==1,11),stat.Trials(stat.Trials(:,columnCond2) ==1,9),alpha);
title('means and confidence intervals')
set(gcf,'Position',get(0,'Screensize'))% enlarge image to full screen
stat.plotname = ['myPlot',data.Subinfo{4},datestr(now, 'yyyymmddTHHMMSS'),'.png'];
print('-dpng','-r300', stat.plotname)

end