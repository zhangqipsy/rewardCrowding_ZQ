function wrkspc = expCrowding(isDemo, once_on, procedureChannel, Constantparams)

  % default values if no input is given
  if nargin < 1
    isDemo = 0;
    once_on = 0;
  end
  if nargin < 3
    procedureChannel = 'QUEST';
  end
    mode.demo_on = isDemo;        % sets totalTrials to the lowest mimimum if repetitions is 0 (also no feedback)
    mode.once_on = once_on; % overrises all trial numbers; number of total trials (0 to cancel this effect)    
    mode.procedureChannel = procedureChannel; % experiment methods;
    conf.Constantparams   = Constantparams; % the column indicators for seperate QUEST sequences (5,6 are distance, color for target)
    mode.crowding_on = 1; % data saving and render.task (instructions etc.)
    conf.nStims = 1;
    mode.debug_on = 0;
    conf.fixLevels = [.3];
    %conf.color.targets = [conf.color.red, conf.color.green]; % this is default
    mode.exclusiveTargetFlankerColor_on = 1;
    conf.deg.cir_r       = 0.55/2;
    fromLab.red = [222  52  70];
    fromLab.green = [0   138  33];
    conf.color.distractors = {fromLab.red ,fromLab.green};
    conf.targetShapes = [Inf 6];
    conf.distractorShapes = [Inf]; % Inf is circle
    conf.deg.targetDist = [6 12];
    conf.deg.range_r = [4 8]; %column7 targetflankerDist
    conf.adaptiveColumn = 7; % 5: targetDist, 7: flankerDist
    conf.repetitions = 1;
    conf.QUESTparams  = {conf.adaptiveColumn conf.repetitions 0 4 0.82 3.5 0.01 0.5}; % columnN,totalTrials,guess,guessSD,pThreshold,beta,delta,gamma
    conf.totalTrials = 1008; % respects this if repititions is zero
    wrkspc = rewardedLearning(conf, mode);
   
end
