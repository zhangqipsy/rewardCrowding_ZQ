function status = test(testWhat)
    switch(testWhat)
        case {'draw'}
            [conf, mode] = loadDefaultConfs();
            data.Trials = genSequence(conf, mode);
            iTrial = 1;
            render.wsize = [0 0 600 800];
            render.cx = render.wsize(3)/2;
            render.cy = render.wsize(4)/2;
            data.draw = genRewardData(data.Trials(iTrial, :), render, conf, mode);
            data.draw1 = drawObjects([], [], data.draw);
            keyboard
        case {'reward'}
            mode.debug_on = 1;      % smaller screen
            conf.repetitions = 1;    % repetition of each condition (if set to 0, uses totalTrials below instead)
            conf.totalTrials = 1008; % respects this if repititions is zero
            mode.demo_on = 1;        % sets totalTrials to the lowest mimimum if repetitions is 0 (also no feedback)
            mode.once_on = 6; % overrises all trial numbers; number of total trials (0 to cancel this effect)
            rewardedLearning(conf, mode)
        case {'crowding'}
          mode.linearStim_on = 1;

        otherwise
            disp('No test specified!')
    end
end
