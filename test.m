function status = test(testWhat)
    switch(testWhat)
        case {'draw'}
            [conf, mode] = loadDefaultConfs();
            data = genSequence(conf, mode);
            iTrial = 1;
            render.wsize = [0 0 600 800];
            render.cx = render.wsize(3)/2;
            render.cy = render.wsize(4)/2;
            data.draw = genRewardData(data.Trials(iTrial, :), render, conf, mode);
            data.draw1 = drawObjects([], [], data.draw);
            keyboard
        case {'reward'}
            rewardedLearning()
        otherwise
            disp('No test specified!')
    end
end
