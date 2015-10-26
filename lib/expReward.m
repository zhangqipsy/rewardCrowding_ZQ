function wrkspc = expReward(isDemo, once_on, procedureChannel)

  % default values if no input is given
  if nargin < 1
    isDemo = 0;
    once_on = 0;
  end
  if nargin < 3
    procedureChannel = 'Constant';
  end

    mode.debug_on = 0;      % smaller screen
    mode.inspectDesign_on = 0;
    mode.procedureChannel = procedureChannel; % experiment methods;
    %mode.procedureChannel = 'Constant'; % experiment methods;
    conf.repetitions = 2;    % repetition of each condition (if set to 0, uses totalTrials below instead)
    conf.totalTrials = 1008; % respects this if repititions is zero
    mode.demo_on = isDemo;        % sets totalTrials to the lowest mimimum if repetitions is 0 (also no feedback)
    mode.once_on = once_on; % overrises all trial numbers; number of total trials (0 to cancel this effect)
    wrkspc = rewardedLearning(conf, mode)
end
