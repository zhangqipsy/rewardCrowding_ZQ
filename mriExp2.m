function s2 = mriExp2()
%% this code
% deals with the predicted altruism
% 150609

clear all;
global leftKey  rightKey escapeKey iCounter Events time_init;

iCounter = 1;
Events = NaN(5, 5);

subinfo = getSubInfo;
seqChoice = genseq_choice;  % for predicted altruism
a2 = item_liangbiao;
designChoice = [a2.all(seqChoice(:, [1 2])) num2cell(seqChoice(:, [3 4]))];
disp(designChoice);
%keyboard;


try
    if exist('./data', 'dir') ~= 7
        mkdir('data');
    end

    AssertOpenGL; % Check if PTB-3 is properly installed on the system

    KbName('UnifyKeyNames');
    leftKey=KbName('3#');
    rightKey=KbName('4$');
    escapeKey=KbName('escape');
    %Screen('Preference', 'SkipSyncTests', 1); % drop for formal exp.

    screens=Screen('Screens');
    screenNumber=max(screens);

    % [wptr, wrect] = Screen('OpenWindow', screenNumber,0,  [300,50, 1300, 600]);% FOR debug
    [wptr, wrect] = Screen('OpenWindow', screenNumber,0);  % for formal  exp.
    [xcenter,ycenter] = RectCenter(wrect);
    HideCursor;

    Screen(wptr,'TextStyle',0);
    Screen('Preference', 'TextRenderer', 1);
    Screen('Preference', 'TextAntiAliasing', 1);
    Screen('TextFont', wptr, 'Microsoft Simsun'); % or `Microsoft Simsun`?
    Screen('TextSize', wptr, 20); % ziti size

    time_init = GetSecs; % record from this very moment.
    showCoverStory(wptr, 3);
    trigger_mri(wptr, wrect, getTime('DummyScan')); % send s to trigger and dummy scan for 12s

    initializeSeq2(wptr, 28, xcenter, ycenter, wrect, seqChoice);

    sayGoodbye(wptr, 255, 0);

    filename = [subinfo{1} '_' datestr(now, 30)];
    save(['./data/' filename],'Events');
    save(['./data/' filename '_full']);
    save all;
    s2 = load('all');
    sca;
    ListenChar(0);
    ShowCursor;
catch
    filename = [subinfo{1} '_' datestr(now, 30)];
    save(['./data/' filename '_buggy']);
    save all;
    s2 = load('all');
    sca;
    psychrethrow(psychlasterror);
    ListenChar(0);
    ShowCursor;
end
end
