function str = instrDB(task, english_on)

if english_on
    switch task
        case {'RewardTask', 'RewardDemo'}
            str = ['\nIn this exprtiment 6 circles will be displayed. ' ...
                '\n' ...
                '\nAnd there will be one bar in each circle. ' ...
                '\n' ...
                '\nThe task is to judge whether there is a vertical or horizontal bar. ' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\nPress z key for a vertical bar.' ...
                '\n' ...
                '\nPress m key for a horizontal bar.' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\nThere is only one target in each trial. ' ...
                '\n' ...
                '\nTry to press the key as soon as possible. ' ...
                '\n' ...
                '\n' ...
                '\nTime is limited and the reward is based on your response. ' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\nPress any key to continue.'];
        case 'rewardFeedback'
            str = ['\n + %.2f.' ...
                '\n' ...
                '\n' ...
                '\n' ...
                'Total: %.2f'];

        case 'CrowdingTask'
            str = ['\n  ' ...
                'Welcome to crowding Experiment!\n' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\nPress z key for a circle.' ...
                '\n' ...
                '\n' ...
                '\nPress m key for a polygon.' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\nPress any key to continue.'];
        case 'rest'
            str = ['\nPlease rest for %f seconds.' ...
                '\n' ...
                '\n' ...
                '\n' ...
                '\nIf you want to proceed, press any button.'];
        otherwise
            str = ['Unknown task!'];
    end
else
    switch task
        case {'RewardTask', 'RewardDemo'}
            str = ['\n\n本实验中，会呈现6个圆形，每个圆形中都会有一个棒。' ...
                '\n\n' ...
                '\n\n任务就是在呈现的6个棒中找到垂直或水平的棒，请作出相应按键反应。' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n如果发现棒是垂直的，请按键盘z。' ...
                '\n\n如果发现棒是水平的，请按键盘m。' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n每一次呈现中只会有一个唯一的目标。' ...
                '\n\n要在保证正确的前提下尽可能快的作反应。' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n反应有时间限制，并且会根据您的反应给予相应的奖赏。'...
                '\n\n' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n按任意键开始实验。'];

        case 'rewardFeedback'
            str = ['\n + %.2f.' ...
                '\n' ...
                '总额: %.2f'];
        case 'CrowdingTask'
            str = ['\n + ' ...
                '欢迎参与视觉拥挤实验!\n' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n如果发现圆形的，请按键盘z。' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n如果发现多边形的，请按键盘m。' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n' ...
                'Total: %.2f'];
        case 'rest'
            str = ['\n\n请休息%s秒。' ...
                '\n\n' ...
                '\n\n' ...
                '\n\n请按任意键继续。'];
        otherwise
            str = ['未知任务'];
    end

end
