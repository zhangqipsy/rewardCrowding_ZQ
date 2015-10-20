function status = test(testWhat)
startup;
if nargin == 0
  testWhat = 'crowding';
end


switch(testWhat)
  case {'draw', 'drawReward'}
    set_test_gamma;
    [conf, mode] = loadDefaultConfs();
    data.Trials = genRewardSequence(conf, mode);
    iTrial = 1;
    render.wsize = [0 0 600 800];
    render.cx = render.wsize(3)/2;
    render.cy = render.wsize(4)/2;
    data.draw = genRewardData(data.Trials(iTrial, :), render, conf);
    data.draw1 = drawObjects([], [], data.draw);
    reset_gamma;
  case {'drawCrowding'}
    set_test_gamma;
    Screen('Preference', 'Verbosity', 0);
    [conf, mode] = loadDefaultConfs();
    mode.exclusiveTargetFlankerColor_on = 1;
    data.Trials = genCrowdingSequence(conf, mode);
    iTrial = 1;
    render.wsize = [0 0 600 800];
    render.cx = render.wsize(3)/2;
    render.cy = render.wsize(4)/2;
    % we are going through the Constant tunnel here
    [data.Trials(iTrial, :), Q] = tunnelUpdate(mode.procedureChannel, conf, data.Trials(iTrial, :), [], data.Trials(:,2));
    data.draw = genCrowdingData(data.Trials(iTrial, :), render, conf);
    %save /scratch/buggy
    %data.Trials(iTrial,:), data.draw.circle, data.draw.poly
    data.draw1 = drawObjects([], [], data.draw);
    reset_gamma;
  case {'reward'}
    mode.debug_on = 0;      % smaller screen
    mode.inspectDesign_on = 0;
    mode.procedureChannel = 'Constant'; % experiment methods;
    conf.repetitions = 2;    % repetition of each condition (if set to 0, uses totalTrials below instead)
    conf.totalTrials = 1008; % respects this if repititions is zero
    mode.demo_on = 0;        % sets totalTrials to the lowest mimimum if repetitions is 0 (also no feedback)
    mode.once_on = 0; % overrises all trial numbers; number of total trials (0 to cancel this effect)
    rewardedLearning(conf, mode)
  case {'crowding'}
    mode.crowding_on = 1; % data saving and render.task (instructions etc.)
    conf.nStims = 1;
    mode.debug_on = 0;
    conf.fixLevels = [.3];
    %conf.color.targets = [conf.color.red, conf.color.green]; % this is default
    mode.exclusiveTargetFlankerColor_on = 1;
    fromLab.red = [238.51  1.14  36.38];
    fromLab.green = [0   138.46  33.43];
    conf.color.distractors = {fromLab.red ,fromLab.green};
    conf.metric.targetDist = [0 677];
    conf.Constantparams     = [5 6]; % the column indicators for seperate QUEST sequences (5,6 are distance, color for target)
    conf.targetShapes = [Inf 8];
    conf.distractorShapes = [Inf]; % Inf is circle
    conf.metric.range_r = -1;
    mode.procedureChannel = 'QUEST'; % experiment methods;
    conf.QUESTparams        = {7 1 3 0.2 0.82 3.5 0.01 0.5}; % columnN,totalTrials,guess,guessSD,pThreshold,beta,delta,gamma
    conf.repetitions      = conf.QUESTparams{2};
    rewardedLearning(conf, mode)
  otherwise
    disp('No test specified!')
end


end

