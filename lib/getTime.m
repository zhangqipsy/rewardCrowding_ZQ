function MyTime = getTime(type, ratio, isDebug)

if nargin < 2
    ratio = 1;
end
if nargin < 3
isDebug = 0; % shortens time
end

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
        MyTime = 20; % wait black screen between Trials, random
    case {'CountdownAfterRest'}
        MyTime = 10;
    case {'BlankAfterResp'}
        MyTime = 1;
    case {'audioTone'}
        MyTime = 0.5; % 500 ms
    case {'ShowFeedback'}
        MyTime = 1.5;
    otherwise
        MyTime = 1;
        error('exp:Mytime', 'No time found!');
end

if isDebug
    MyTime = 0.01* MyTime;
end

end
