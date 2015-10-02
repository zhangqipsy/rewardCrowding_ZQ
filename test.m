function status = test(testWhat)
startup;
if nargin == 0
  testWhat = 'drawCrowding';
end
%try
    switch(testWhat)
        case {'draw', 'drawReward'}
            [conf, mode] = loadDefaultConfs();
            data.Trials = genRewardSequence(conf, mode);
            iTrial = 1;
            render.wsize = [0 0 600 800];
            render.cx = render.wsize(3)/2;
            render.cy = render.wsize(4)/2;
            data.draw = genRewardData(data.Trials(iTrial, :), render, conf, mode);
            data.draw1 = drawObjects([], [], data.draw);
            keyboard
        case {'drawCrowding'}
          Screen('Preference', 'Verbosity', 0);
            [conf, mode] = loadDefaultConfs();
            data.Trials = genCrowdingSequence(conf, mode);
            iTrial = 1;
            render.wsize = [0 0 600 800];
            render.cx = render.wsize(3)/2;
            render.cy = render.wsize(4)/2;
            mode.procedurechannel = 'quest'; % experiment methods;
            conf.questparams        = {7 100 0.1 0.8}; % fixme: dunno what it means
            [data.Trials(iTrial, :) Q]= tunnelUpdate(mode.procedureChannel, conf, data.Trials(iTrial, :), [], data.Trials(:,2));
            data.draw = genCrowdingData(data.Trials(iTrial, :), render, conf, mode);
            %save /scratch/buggy
            %data.Trials(iTrial,:), data.draw.circle, data.draw.poly
            pause

            data.draw1 = drawObjects([], [], data.draw);
        case {'reward'}
            mode.debug_on = 1;      % smaller screen
            mode.inspectDesign_on = 0;
            mode.procedureChannel = 'Constant'; % experiment methods;
            conf.repetitions = 1;    % repetition of each condition (if set to 0, uses totalTrials below instead)
            conf.totalTrials = 1008; % respects this if repititions is zero
            mode.demo_on = 1;        % sets totalTrials to the lowest mimimum if repetitions is 0 (also no feedback)
            mode.once_on = 6; % overrises all trial numbers; number of total trials (0 to cancel this effect)
            rewardedLearning(conf, mode)
        case {'crowding'}
          mode.linearStim_on = 1;
          conf.nStim = 1;
          conf.fixLevels = [.3];
          %conf.color.targets = [conf.color.red, conf.color.green];
          conf.color.targets = [conf.color.red, conf.color.green];
          conf.metric.targetDist = [2 4 8];
          conf.Constantparams     = [5 6]; % the column indicators for seperate QUEST sequences (5,6 are distance, color for target)
          conf.targetShapes = [Inf 8];
          conf.validKeys          = {'space', 'escape', 'z', 'm'}; % always keep espace and space in this order!
          conf.distractorShapes = [Inf]; % Inf is circle
          conf.metric.range_r = -1;
          mode.procedurechannel = 'quest'; % experiment methods;
          conf.questparams        = {7 100 0.1 0.8}; % fixme: dunno what it means
          conf.repititions = conf.QUESTparams{2};
        otherwise
            disp('No test specified!')
    end

%catch
    %sca;
%end %try

end

