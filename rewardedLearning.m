function wrkspc = rewardedLearning(conf, mode, Subinfo)
%REWARDEDLEARNING serves both as the demo and the real experiment.
%
% SYNOPSIS: wrkspc = rewardedLearning(isRedHigh, isDemo)
%
% INPUT isRedHigh
%			Red target is the higher reward, contrary to the greed being the higher one.
%		isDemo
%			Demo for the experiment, before the real learning experiment begins.
%		All other settings and configurations of the expreiment could be changed directly by changing the value of the `conf` struct.
%
% OUTPUT wrkspc
%			All the useful variabl;es, includes everything except `render` struct
%

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 Professional Version 6.3 (Build 9600)
%
% Author: Hormet, 2015-08-31
% UPDATED: 2015-08-31 14:23:42
%
% HISTORY
% yyyy-dd-mm	whoami	log
% 2015-08-31	Hormet	Created it.
%
%
% Copyright 2015 by Hormet <hyiltiz@gmail.com>
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flow.iniTimer = GetSecs;
addpath('./data', './lib', './lib/misc', './resources');
data=struct();

% input variables, use them via updateStruct() to update the defined variables below
% these conf, mode was defined through wrapper shells such as DirectionTask
if nargin > 0
    render.conf=conf;
    render.mode=mode;
end

[conf, mode] = loadDefaultConfs();
% evaluate the input arguments of this function
if nargin > 0
    conf = updateStruct(render.conf, conf);
    mode = updateStruct(render.mode, mode);
end

try


    render.dataPrefix=[];
    render.dataSuffix=[];
    if mode.demo_on
        render.dataPrefix = ['Demo/'];
        render.dataSuffix = [render.dataSuffix '_RawardDemo_'];
        render.task = 'RewardDemo';
    else
        render.dataPrefix = ['RewardTask/'];
        render.dataSuffix = [render.dataSuffix '_RawardTask_'];
        render.task = 'RewardTask';
    end

    switch mode.colorBalance_on
        case 0
            % auto-balance the color
            if round(rand)
                conf.idxHighRewardColor = 1;        
                render.dataSuffix = [render.dataSuffix '_redTarget_'];
            else
                conf.idxHighRewardColor = 2;        
                render.dataSuffix = [render.dataSuffix '_greenTarget_'];
            end
            render.dataSuffix = [render.dataSuffix '_autoColorBalance_'];
        case 1
            conf.idxHighRewardColor = mode.colorBalance_on;
            render.dataSuffix = [render.dataSuffix '_redTarget_'];
            render.dataSuffix = [render.dataSuffix '_manualColorBalance_'];
        case 2
            conf.idxHighRewardColor = mode.colorBalance_on;
            render.dataSuffix = [render.dataSuffix '_greenTarget_'];
            render.dataSuffix = [render.dataSuffix '_manualColorBalance_'];
        otherwise
            error('rewardCrowding:modeColorBalance', 'Undefined mode.colorBalance_on: %d', mode.colorBalance_on');
            manualAbort();
    end


    data.Trials = genSequence(conf, mode);  % for predicted altruism
    Display('Please make sure that this design is correct. Insert `dbcont` to continue, or `dbquit` to abort');

    %% exp begins
    %keyboard;

    if exist('./data', 'dir') ~= 7
        mkdir('data');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Hardware/Software Check
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % make sure the software version is new enouch for running the program
    checkVersion();

    % unified key definitions
    render.kb = keyDefinition();

    % psychoaudio hardware setting.
    if mode.audio_on
        %render.pahandle = loadAudio(conf.audioFreq);
        data.audio.tone1(1,:) = MakeBeep(conf.audioTone1Hz, getTime('audioTone', mode.debug_on), conf.audioFreq); % target
        data.audio.tone1(2,:) = data.audio.tone1(1,:);
        data.audio.tone2(1,:) = MakeBeep(conf.audioTone2Hz, getTime('audioTone', mode.debug_on), conf.audioFreq);
        data.audio.tone2(2,:) = data.audio.tone2(1,:); % tone2 is the last tone that indicate the end of the sound sequence.
    end

    % Get Subject information
    if exist('Subinfo','var');data.Subinfo = Subinfo; else data.Subinfo = getSubInfo();end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% initialization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AssertOpenGL; % Check if PTB-3 is properly installed on the system
    HideCursor;
    ListenChar(2);
    if mode.debug_on
        Screen('Preference','SkipSyncTests', 0);
    else
        Screen('Preference','SkipSyncTests', 0);
    end
    Screen('Preference', 'ConserveVRAM', 8);
    InitializeMatlabOpenGL;

    render.screens=Screen('screens');
    render.screenNumber=max(render.screens);

    if mode.debug_on
        [w,render.wsize]=Screen('OpenWindow',render.screenNumber,conf.color.backgroundColor,[1,1,801,601],[]);
    else
        [w,render.wsize]=Screen('OpenWindow',render.screenNumber,conf.color.backgroundColor,[],32);
    end
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);



    render.ifi=Screen('GetFlipInterval', w);
    if render.ifi > conf.flpi + 0.0005 % allow 0.5ms error
        error('HardwareError:MonitorFlushRate',...
            'Monitor Flip Interval is too large. Please adjust monitor flush rate \n from system preferences, or adjust conf.flpi fron *Task.m file.');
    end
    Priority(MaxPriority(w));

    HideCursor;

    Screen(w,'TextStyle',0);
    Screen('Preference', 'TextRenderer', 1);
    Screen('Preference', 'TextAntiAliasing', 1);
    Screen('TextFont', w, 'Microsoft Simsun'); % or `Microsoft Simsun`?
    Screen('TextSize', w, 20); % ziti size

    render.cx = render.wsize(3)/2; %center x
    render.cy = render.wsize(4)/2; %center y
    
    % NOT used by now; could be convenient when none of the conf are needed
    render.backgroundColor = conf.color.backgroundColor; 


    %% Instructions
    DrawFormattedText(w, instrDB(render.task, mode.english_on), 'center', 'center', conf.color.textcolor);
    Screen('Flip', w);
    if mode.recordImage; recordImage(1,1,[render.task '_instr'],w,render.wsize);end
    %if ~mode.debug_on;Speak(sprintf(instrDB(render.task, mode.english_on)));end
    KbWait;



    flow.nresp    = 1;  % the total number of response recorded 
    flow.restcount= 0;  % the number of trials from last rest
    flow.trialID = 1;
    %% Here begins our trial
    while true
        % only ends when ALL trials have collected correct response
        % see recordResponse()

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% data generatoin
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data.draw = genRewardData(data.Trials(flow.nresp, :), render, conf, mode);

        % per trial initialization
        flow.response = 0;  % the current current response, just after the last response
        flow.isquit = 0;     % to capture ESCAPE for quitting
        flow.iniTimer=[flow.iniTimer GetSecs];


        %      tic;


        % rest every couple trials once
        if flow.nresp > 1
            WaitSecs(eps);

            if mod(flow.nresp, conf.showLeftTrialsEvery) == 0
                showLeftTrial(data.Trials, flow.nresp, w, render.wsize, mode.debug_on, mode.english_on, render.kb, 1, mode.serialInput_on);
            end
            if mode.recordImage; recordImage(1,1,[render.task '_remaining'],w,render.wsize);end
        end

        flow.restcount = restBetweenTrial(flow.restcount, getTime('RestBetweenBlocks', mode.debug_on), conf.restpertrial, w, render.wsize, mode.debug_on, mode.english_on, render.kb, 1, mode.serialInput_on);

        % NOTE: do we need wait black screen between Trials, random?
        WaitSecs(getTime('WaitBetweenTrials', mode.debug_on));  % wait black screen between Trials, random

        if mode.recordImage; recordImage(1,1,[render.task '_mirror'],w,render.wsize); end


        Screen('FillRect',w, conf.color.backgroundColor);
        render.vlb = Screen('Flip', w);  % record render.vlb, used for TIMING control



        %% now prsent Stim that you can see on the screen
        % show fixation
        fixation(w, '+', conf.color.fix, conf.color.backgroundColor);
        render.vlb = Screen('Flip', w);
        WaitSecs(data.Trials(flow.nresp, 4));

        % present stimuli
        data.drawed = drawObjects(w, render, data.draw);
        render.vlb = Screen('Flip', w, render.vlb + (1-0.5)*conf.flpi);%use the center of the interval
        % Flip the visual stimuli on the screen, along with timing
        % old = render.vlb;
        if mode.recordImage; recordImage(flow.Flip,10,render.task ,w,render.wsize);end


        % get the response
        [flow.rt flow.response flow.respTime] = collectResponse(conf.validKeys(2:end), getTime('TrialDuration', mode.debug_on), GetSecs); % first one is space

        Screen('FillRect',w, conf.color.backgroundColor);
        render.vlb = Screen('Flip', w);  % record render.vlb, used for TIMING control
        WaitSecs(getTime('BlankAfterResp', mode.debug_on));

        Display(flow.response);
        switch flow.response
            case {'Escape', 'escape'}
                flow.isquit = 1;
                manualAbort();

            case conf.validKeys(3:end) % all stimuli (first two are space and escape)
                % NOTE: here assuming that conf.validKeys have space, escape as the first two
                flow.idxResponse = find(strcmpi(conf.validKeys, flow.response))-2;

                % record response
                [data, flow] = recordResponse(flow, data, conf);

                if ~mode.demo_on
                    % demo_on calcels feedback
                % give feedback
                if flow.isCorrect
                    DrawFormattedText(w, sprintf(instrDB('rewardFeedback', mode.english_on), data.Trials(flow.nresp-1, 15), sum(data.Trials(:, 15))), 'center', 'center', conf.color.textcolor2);
                    render.vlb = Screen('Flip', w);  % record render.vlb, used for TIMING control
                    WaitSecs(getTime('ShowFeedback', mode.debug_on));
                end
            end

            case {'DEADLINE'}
                % deadline is reached!
                % record this as -1
                % NOTE: encoding as -1 treats the reponse as INCORRECT, which in turn
                % remembers this trial for later data recollection 
                flow.idxResponse = -1;
                [data, flow] = recordResponse(flow, data, conf);

                % Here comes the sound
                if mode.audio_on; 
                    %playSound(pahandle, conf.audioFreq, data.paceRate, data.moveDirection(flow.nresp, 1));
                    Snd('Play',data.audio.tone2, conf.audioFreq,16);
                end


                %Screen('FillRect',w, conf.color.backgroundColor);
                %render.vlb = Screen('Flip', w);  % record render.vlb, used for TIMING control
                %WaitSecs(getTime('', mode.debug_on));

            otherwise
                error('rewardedLearning:collectResponse', 'keys other than validKeys are collected');
        end

        % end of per trial
        Screen('FillRect',w, conf.color.backgroundColor);
        WaitSecs(getTime('BlankAfterTrial', mode.debug_on));
        Screen('Flip', w);



        % do exactly once_on times
        %mode.once_on = mode.once_on-1;
        %if ~mode.once_on; flow.isquit = 1;warning('Preparation Finished! (No worries. This is no bug, buddy.)'); end


        Display(flow.isquit)
        if flow.isquit
            % End of experiment
            break
        end;

    end % while true




    Display(char('','','data/latest.mat saved successfully, use for debugging!',''));
    render.matFileName = ['data/',render.dataPrefix, data.Subinfo{1} , render.dataSuffix, date, '.mat'];
    save(render.matFileName,'Trials','conf','flow','mode','data');
    wrkspc = load(render.matFileName);
    Display(render.matFileName);


    % Display 'Thanks' Screen
    if true
        % this is the correct ending of the experiment
        RL_Regards(w, mode.english_on);
    else
        % not end yet
        % do the following test here
    end

catch
    % always save the buggy data for debugging
    save data/buggy.mat;
    Display(char('','','data/buggy.mat saved successfully, use for debugging!',''));
    save(['data/', render.dataPrefix, data.Subinfo{1}, render.dataSuffix, date, 'buggy.mat']);
    wrkspc = load(['data/', render.dataPrefix, data.Subinfo{1}, render.dataSuffix, date, 'buggy.mat']);
    %     disp(['';'';'data/buggy saved successfully, use for debugging!']);
    Screen('CloseAll');
    %if mode.audio_on; PsychPortAudio('Close'); end
    Priority(0);
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
    format short;
end

%% exp ends
Screen('CloseAll');
%if mode.audio_on; PsychPortAudio('Close'); end
Priority(0);
ShowCursor;
ListenChar(0);

% always save the latest data for the last experiment
save data/latest.mat;
Display(char('','','data/latest.mat saved successfully, use for testing!',''));
figure;
%boxplot(Trials(:,3),Trials(:,2));
%title([data.Subinfo{1} ':' render.task]);
%format short;
Display('Experiment was successful!');

end
