function MyTime = getTime(type)

isDebug = 0; % shortens time

switch type
    case {'DummyScan'}
        % dummy MyTime , also for cover story
        MyTime = 12;
    case {'Init_fix'}
        % time between cover story and block instructions
        MyTime = 8;
    case {'Instruction'}
        % instruction for each conditions
        MyTime = 3;
    case {'CrossBeforeEvents'}
        % time between instructions and events
        MyTime = 1;
    case {'TrialDuration'}
        % Trials: altruism, zili,ziti all lasts for 4s.
        MyTime = 4;
    case {'CrossBetweenEvents'}
        % time between two events(altruism, liji, ziti, altruism and liji)
        MyTime = myRand(1,3);
    case {'CrossLinkEventsShock'}
        % time between 4 events and 4 shocks
        MyTime = 6;
    case {'ShockDuration'}
        % time for shock
        MyTime = 3;
    case {'PainRatingWait'}
        MyTime = 5;
    case {'CrossBetweenShockAndRating'}
        % time between shock and painRating
        MyTime = myRand(1,3);
    case {'CrossBetweenShockTrials'}
        % time between two shock trials
        MyTime = myRand(4,8);
    case {'CrossBetweenBlocks'}
        % time between two blocks
        MyTime = myRand(4,8);
    case {'CrossBeforePredictedAl'}
        % time between the main part and the predicted altruism part
        MyTime = 6;
    case {'CrossBetweenPredictedAI'}
        % jitter between two predicted altruism items
        MyTime = myRand(2,6);
    case {'goodbye'}
        MyTime = 6;
    case {'RestBetweenBlocks'}
        MyTime = 20;
    case {'CountdownAfterRest'}
        MyTime = 10;
    otherwise
        MyTime = 1;
        error('exp:Mytime', 'No time found!');
end

if isDebug
    MyTime = 0.01* MyTime;
end

end
