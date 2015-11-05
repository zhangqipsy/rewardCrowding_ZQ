function MyTime = getTime(type, isDebug)

ratio = 1;
if nargin < 2
    isDebug = 0; % shortens time
end
if isDebug; ratio = 1;end

switch type
    case {'flpi'}
MyTime               =  .02;         % each frame is set to 20ms (the monitor's flip interval is 16.7ms)
    case {'Instruction'}
        % for cover Instruction
        MyTime = 10;
    %case {'fixTrial'}
        % fixation time before Trial stimuli
        % NOTE: this is NOT used; it is controlled by condition
        %MyTime = 1;
    case {'TrialDuration'}
        MyTime = .6;
    case {'WaitBetweenTrials'}
        MyTime = 0.8+rand*0.2;
    case {'RestBetweenBlocks'}
        MyTime = 2000; % wait black screen between Trials, random
    case {'CountdownAfterRest'}
        MyTime = 10;
    case {'BlankAfterResp'}
        MyTime = 1;
    case {'CrowdingBlankAfterResp'}
        MyTime = 10;
    case {'BlankAfterTrial'} % NOTE: do we need this? blank background of 1 sec at end of per trial
        MyTime = 1;
    case {'audioTone'}
        MyTime = 0.5; % 500 ms
    case {'ShowFeedback'}
        MyTime = 1.5;
    case {'ShowLeftTrial'}
        MyTime = 0.5;
    otherwise
        MyTime = 1;
        error('exp:Mytime', 'No time found!');
end

if isDebug
    MyTime = ratio* MyTime;
end

end
