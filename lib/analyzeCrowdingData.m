function stat = analyzeCrowdingData(data)
  %exist data.t;
  %data.exist = ans;

  if isfield(data, 't') && ~isempty(data.t)
  %if data.exist % Quest
    stat.result = data.t;

  else % constant
    columnTest1 = 13; % acc
    columnTest2 = 11; % reaction time
    columnCond1 = 2; % conditions
    columnCond2 = 6; % color

    stat.allTrialNum = size(data.Trials,1);
    stat.Trials = data.Trials(data.Trials(:,columnTest2)>0,:);% no NaN

    stat.condiNum1 = numel(unique(stat.Trials(:,columnCond1)));
    stat.condiNum2 = numel(unique(stat.Trials(:,columnCond2)));
    stat.miss = 1-size(stat.Trials,1)/stat.allTrialNum; %the persentage of miss trials

    stat.accAll =mean(stat.Trials(:,13));% acc for all trial with keypress

    [stat.meansdAcc(:,1)] = grpstats( stat.Trials(:, columnTest1), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], {'mean'});
    [stat.meansdRt(:,1) stat.meansdRt(:,2)] = grpstats( stat.Trials(:, columnTest2), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], {'mean', 'std'});

    subplot(1,2,1)
    boxplot( stat.Trials(:, columnTest1), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], 'labels',{'6-color1', '6-color2', '8-color1', '8-color2','10-color1', '10-color2','12-color1', '12-color2'});
    hold on;
    plot(stat.meansdAcc(:,1),'d');
    hold off;
    subplot(1,2,2)
    boxplot( stat.Trials(:, columnTest2), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], 'labels',{'6-color1', '6-color2', '8-color1', '8-color2','10-color1', '10-color2','12-color1', '12-color2'});
    hold on;
    plot(stat.meansdRt(:,1),'d');
    hold off;
  end
end
