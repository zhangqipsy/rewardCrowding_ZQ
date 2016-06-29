function stat = analyzeCrowdingData(data, conf)

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

    stat.allTrialNum = size(data.Trials,1);
    stat.Trials = data.Trials(data.Trials(:,columnTest2)>0,:);% no NaN

    stat.condiNum1 = numel(unique(stat.Trials(:,columnCond1)));
    stat.condiNum2 = numel(unique(stat.Trials(:,columnCond2)));
    stat.miss = 1-size(stat.Trials,1)/stat.allTrialNum; %the persentage of miss trials

    stat.accAll =mean(stat.Trials(:,13));% acc for all trial with keypress
    [stat.meansdAcc(:,1)] = grpstats( stat.Trials(:, columnTest1), [stat.Trials(:,columnCond1),  stat.Trials(:,columnCond2)], {'mean'});
    
    stat.Trials_all = stat.Trials(stat.Trials(:,11)>0,:);
    [stat.meansdRt_all(:,1) stat.meansdRt_all(:,2)] = grpstats( stat.Trials_all(:, columnTest2), [stat.Trials_all(:,columnCond1),  stat.Trials_all(:,columnCond2)], {'mean', 'std'});
   
    stat.Trials_R = stat.Trials(stat.Trials(:,11)>0 & stat.Trials(:,13)==1,:);
    [stat.meansdRt_R(:,1) stat.meansdRt_R(:,2)] = grpstats( stat.Trials_R(:, columnTest2), [stat.Trials_R(:,columnCond1),  stat.Trials_R(:,columnCond2)], {'mean', 'std'});
   
    stat.Trials_W = stat.Trials(stat.Trials(:,11)>0 & stat.Trials(:,13)==0 & stat.Trials(:,19)<=conf.eyeRestrict,:);
    [stat.meansdRt_W(:,1) stat.meansdRt_W(:,2)] = grpstats( stat.Trials_W(:, columnTest2), [stat.Trials_W(:,columnCond1),  stat.Trials_W(:,columnCond2)], {'mean', 'std'});
   
    stat.Trials_Look = stat.Trials(stat.Trials(:,11)>0 & stat.Trials(:,13)==0 & stat.Trials(:,19)>conf.eyeRestrict,:);
    
     stat.Trials_miss = data.Trials(data.Trials(:,11)<0,:);
     tt = unique(stat.Trials(:,columnCond1));
     stat.mean_miss = zeros(1,numel(unique(stat.Trials(:,columnCond1))));
      stat.mean_Look = zeros(1,numel(unique(stat.Trials(:,columnCond1))));
     for ii = 1:numel(unique(stat.Trials(:,columnCond1)))
         temp_data = stat.Trials_miss(stat.Trials_miss(:,2) == tt(ii,1),:);
         if ~isempty(temp_data)
        stat.mean_miss(1,ii) = sum(temp_data(:,6))/(stat.allTrialNum/stat.condiNum1);
         end
         temp_data2 = stat.Trials_Look(stat.Trials_Look(:,2) == tt(ii,1),:);
         if ~isempty(temp_data2)
        stat.mean_Look(1,ii) = sum(temp_data2(:,6))/(stat.allTrialNum/stat.condiNum1);
         end
     end
     stat.All_result = zeros(9,stat.condiNum1);
     stat.All_result(1,:) = stat.meansdAcc(:,1)';
     
     stat.All_result(2,1:stat.condiNum1) = stat.meansdRt_all(:,1)';
     stat.All_result(3,1:stat.condiNum1) = stat.meansdRt_all(:,2)';
     
     stat.All_result(4,1:stat.condiNum1) = stat.meansdRt_R(:,1)';
     stat.All_result(5,1:stat.condiNum1) = stat.meansdRt_R(:,2)';
     
     stat.All_result(6,1:stat.condiNum1) = stat.meansdRt_W(:,1)';
     stat.All_result(7,1:stat.condiNum1) = stat.meansdRt_W(:,2)';
     
      stat.All_result(8,1:stat.condiNum1) = stat.mean_Look(1,:);
      stat.All_result(9,1:stat.condiNum1) = stat.mean_miss(1,:);
     
     
     
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
    plot(stat.meansdRt_all(:,1),'d');
    hold off;
    set(gcf,'Position',get(0,'Screensize'))% enlarge image to full screen
    stat.plotname = ['myPlot',data.Subinfo{1},datestr(now, 'yyyymmddTHHMMSS'),'.png'];
    print('-dpng','-r300', stat.plotname)
  end
end
