function stat = analyzeCrowdingData(data)

  if isfield(data, 't') && ~isempty(data.t)
  %if data.exist % Quest
    stat.result = data.t;
    figure('visible','off');
    h=bar(data.stat.result(:,2),'c');
    hold on
    h = errorbar(data.stat.result(:,2),data.stat.result(:,3), 'ko');
    xlabel('t')
    ylabel('deg')
    set(gca,'XtickLabel',data.stat.result(:,1))
    hold off
    stat.plotname = ['myPlot',data.Subinfo{4},datestr(now, 'yyyymmddTHHMMSS'),'.png'];
    print('-dpng','-r300', stat.plotname)

  else % constant
    columnTest1 = 13; % acc
    columnTest2 = 11; % reaction time
    columnCond1 = 2; % conditions
    columnCond2 = 6; % color
    stat.label1 = 'distants';
    stat.label2 = 'color';

    stat.allTrialNum = size(data.Trials,1);
    stat.Trials = data.Trials(data.Trials(:,columnTest2)>0,:);% no NaN

    stat.condiNum1 = numel(unique(stat.Trials(:,columnCond1)));
    stat.condiNum2 = numel(unique(stat.Trials(:,columnCond2)));
    stat.miss = 1-size(stat.Trials,1)/stat.allTrialNum; %the persentage of miss trials

    stat.accAll =mean(stat.Trials(:,13));% acc for all trial with keypress

    [stat.meansdAcc(:,1)] = grpstats( stat.Trials(:, columnTest1), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], {'mean'});
    [stat.meansdRt(:,1) stat.meansdRt(:,2)] = grpstats( stat.Trials(:, columnTest2), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], {'mean', 'std'});
    figure('visible','off');
    subplot(1,2,1)
    boxplot( stat.Trials(:, columnTest1), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], 'labels',{'6-c1', '6-c2', '8-c1', '8-c2','10-c1', '10-c2','12-c1', '12-c2'});
    hold on;
    plot(stat.meansdAcc(:,1),'d');
    hold off;
    subplot(1,2,2)
    boxplot( stat.Trials(:, columnTest2), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], 'labels',{'6-c1', '6-c2', '8-c1', '8-c2','10-c1', '10-c2','12-c1', '12-c2'});
    hold on;
    plot(stat.meansdRt(:,1),'d');
    hold off;
    set(gcf,'Position',get(0,'Screensize'))% enlarge image to full screen
    stat.plotname = ['myPlot',data.Subinfo{4},datestr(now, 'yyyymmddTHHMMSS'),'.png'];
    print('-dpng','-r300', stat.plotname)
  end
end
