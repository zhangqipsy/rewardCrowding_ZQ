function wrkspc = expCrowding(isDemo, once_on, procedureChannel, Constantparams)

  % default values if no input is given
  if nargin < 1
    isDemo = 0;
    once_on = 0;
  end
  if nargin < 3
    procedureChannel = 'QUEST';
  end
    conf.showLeftTrialsEvery = 10000;
    mode.eyetracking_mode = 0;
    mode.persistentFix  = 1;
    mode.drawBlackCircle = 1;
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
    conf.deg.cir_r       = 1/2;
    fromLab.cyan = [4 157 196]; % L=60 c=36 h=-124
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fromLab.cyan1 = [64 184 224];
    fromLab.cyan2 = [99 212 253];
    fromLab.orange1 = [85 37 2];
    fromLab.orange2 = [112 59 26];
    fromLab.orange3 = [139 83 48];
    fromLab.orange4 = [167 107 71];
    fromLab.orange5 = [225 159 121];
    fromLab.orange6 = [255 186 146];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fromLab.orange = [193 130 93]; % L=60 c=36 h=56
    fromLab.purple = [180 127 180];
% use these when reward color can both be target and flankers
%     conf.color.targets = {fromLab.cyan ,fromLab.orange ,fromLab.purple};
%     conf.color.distractors = {fromLab.cyan ,fromLab.orange ,fromLab.purple};
    conf.color.targets = {fromLab.purple};
    %conf.color.distractors = {fromLab.cyan ,fromLab.orange};
    conf.color.distractors = {fromLab.orange,fromLab.cyan};
    conf.targetShapes = [Inf 6];
    conf.distractorShapes = [Inf]; % Inf is circle
    conf.deg.targetDist = [9];
    %TRY
    conf.deg.range_r = [0 5];%column7 targetflankerDist
    conf.repetitions = 20;
    conf.showTime = [1];
    mode.drawBlackCircle = 1;
    %TEST
    conf.deg.range_r = [1.5];
    conf.repetitions = 40;
    mode.drawBlackCircle = 0;
    conf.showTime = [0.05 0.1 0.15 0.6];
    %conf.adaptiveColumn = 7; % 5: targetDist, 7: flankerDist
    conf.adaptiveColumn = NaN;
    conf.QUESTparams  = {conf.adaptiveColumn conf.repetitions 0 4 0.82 3.5 0.01 0.5}; % columnN,totalTrials,guess,guessSD,pThreshold,beta,delta,gamma
    conf.totalTrials = 1008; % respects this if repititions is zero
    wrkspc = rewardedLearning(conf, mode);
   
end
