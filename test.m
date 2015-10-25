function status = test(testWhat)
startup;
if nargin == 0
  testWhat = 'crowding';
end


switch(testWhat)
  case {'draw', 'drawReward'}
    set_test_gamma;
    [conf, mode] = loadDefaultConfs();
    render.backgroundColor = conf.color.backgroundColor;
    data.Trials = genRewardSequence(conf, mode);
    iTrial = 1;
    data.draw = genRewardData(data.Trials(iTrial, :), render, conf);
    data.draw1 = drawObjects([], [], data.draw);
    reset_gamma;

  case {'drawCrowding'}
    set_test_gamma;
    [conf, mode] = loadDefaultConfs();
    render.backgroundColor = conf.color.backgroundColor;
    mode.exclusiveTargetFlankerColor_on = 1;
    conf.deg.targetDist = [60];
    conf.adaptiveColumn = 7; % 5: targetDist, 7: flankerDist
    data.Trials = genCrowdingSequence(conf, mode);
    iTrial = 1;
    % we are going through the Constant tunnel here [default]
    [data.Trials(iTrial, :), Q] = tunnelUpdate(mode.procedureChannel, conf, data.Trials(iTrial, :), [], data.Trials(:,2));
    data.draw = genCrowdingData(data.Trials(iTrial, :), render, conf);
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
    fromLab.red = [222  52  70];
    fromLab.green = [0   138  33];
    conf.color.distractors = {fromLab.red ,fromLab.green};
    conf.deg.targetDist = [8 30];
    conf.deg.range_r = [4 8];
    conf.Constantparams     = [7 5]; % the column indicators for seperate QUEST sequences (5,6 are distance, color for target)
    conf.targetShapes = [Inf 8];
    conf.distractorShapes = [Inf]; % Inf is circle
    conf.adaptiveColumn = 7; % 5: targetDist, 7: flankerDist
    conf.repetitions = 1;
    %mode.procedureChannel = 'constant'; % experiment methods;
    mode.procedureChannel = 'QUEST'; % experiment methods;
    conf.QUESTparams        = {conf.adaptiveColumn conf.repetitions 0 4 0.82 3.5 0.01 0.5}; % columnN,totalTrials,guess,guessSD,pThreshold,beta,delta,gamma
    rewardedLearning(conf, mode)

  otherwise
    disp('No test specified!')
end


end

