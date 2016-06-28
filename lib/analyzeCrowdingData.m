function stat = analyzeCrowdingData(data)

  if isfield(data, 't') && ~isempty(data.t)% Quest
    stat.result = data.t;
    stat.Trials = data.Trials;
    columnTest = 7;
    columnCond1 = 2; % conditions
    stat.condiNum1 = numel(unique(stat.Trials(:,columnCond1)));
    stat.condilabel = unique(stat.Trials(:,columnCond1));
    figure('visible','off');
    for i = 1:stat.condiNum1
        subplot(2,stat.condiNum1/2,i)
        plot(stat.Trials(stat.Trials(:,columnCond1) ==stat.condilabel(i),columnTest));
        title(stat.condilabel(i))
    end
    stat.plotname = ['myPlot',data.Subinfo{1},datestr(now, 'yyyymmddTHHMMSS'),'change','.png'];
    print('-dpng','-r300', stat.plotname)
    
    
    figure('visible','off');
    h=bar(stat.result(:,2),'c');
    hold on
    h = errorbar(stat.result(:,2),stat.result(:,3), 'ko');
    xlabel('t')
    ylabel('deg')
    set(gca,'XtickLabel',stat.result(:,1))
    hold off
    stat.plotname = ['myPlot',data.Subinfo{1},datestr(now, 'yyyymmddTHHMMSS'),'_t','.png'];
    print('-dpng','-r300', stat.plotname)

  else % constant
    columnTest1 = 13; % acc
    columnTest2 = 11; % reaction time
    columnCond1 = 2; % conditions
    columnCond2 = 6; % color

    stat.allTrialNum = size(data.Trials,1)-1;
    stat.Trials = data.Trials(data.Trials(:,columnTest2)>0,:);% no NaN

    stat.condiNum1 = numel(unique(stat.Trials(:,columnCond1)));
    stat.condiNum2 = numel(unique(stat.Trials(:,columnCond2)));
    stat.miss = 1-size(stat.Trials,1)/stat.allTrialNum; %the persentage of miss trials

    stat.accAll =mean(stat.Trials(:,13));% acc for all trial with keypress

    [stat.meansdAcc(:,1)] = grpstats( stat.Trials(:, columnTest1), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], {'mean'});
    [stat.meansdRt(:,1) stat.meansdRt(:,2)] = grpstats( stat.Trials(:, columnTest2), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], {'mean', 'std'});
    figure('visible','off');
    subplot(1,2,1)
    boxplot( stat.Trials(:, columnTest1), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)],'labels',cellstr(num2str([1:numel(unique(stat.Trials(:,2)))]'))');
    title('acc');
    hold on;
    plot(stat.meansdAcc(:,1),'d');
    hold off;
    subplot(1,2,2)
    boxplot( stat.Trials(:, columnTest2), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)],'labels',cellstr(num2str([1:numel(unique(stat.Trials(:,2)))]'))');
    title('RT');
    hold on;
    plot(stat.meansdRt(:,1),'d');
    hold off;
    set(gcf,'Position',get(0,'Screensize'))% enlarge image to full screen
    stat.plotname = ['myPlot',data.Subinfo{1},datestr(now, 'yyyymmddTHHMMSS'),'.png'];
    print('-dpng','-r300', stat.plotname)
  end
end
