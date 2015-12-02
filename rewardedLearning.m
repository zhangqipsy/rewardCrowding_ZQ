function wrkspc = rewardedLearning(conf, mode, Subinfo)
%REWARDEDLEARNING serves both as the demo and the real experiment.
%
% SYNOPSIS: wrkspc = rewardedLearning(conf, mode, Subinfo)
%
%	All settings and configurations of the expreiment could be changed directly by changing the value of the `conf` and `mode` struct
%
% OUTPUT wrkspc
%	All the useful variables, includes everything except `render` struct
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
addpath('./data', './lib', './lib/misc', './lib/gammaCorrection', './resources');
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



    render.dataPrefix=[];
    render.dataSuffix=[];
    if mode.demo_on
        render.dataPrefix = ['Demo/'];
        render.dataSuffix = [render.dataSuffix '_RawardDemo_'];
        render.task = 'RewardDemo';
        mode.feedback_on = 0;
    elseif mode.crowding_on
        render.dataPrefix = ['CrowdingTask/'];
        render.dataSuffix = [render.dataSuffix '_CrowdingTask_'];
        render.task = 'CrowdingTask';
        mode.feedback_on = 0;
    else
        render.dataPrefix = ['RewardTask/'];
        render.dataSuffix = [render.dataSuffix '_RawardTask_'];
        render.task = 'RewardTask';
    end

    switch render.task
        case {'RewardTask', 'RewardDemo'}
            genSequence = @genRewardSequence;
            genData = @genRewardData;
            recordResponse = @recordRewardResponse;
            analyzeData = @analyzeRewardData;
        case {'CrowdingTask'}
            genSequence = @genCrowdingSequence;
            genData = @genCrowdingData;
            recordResponse = @recordCrowdingResponse;
            analyzeData = @analyzeCrowdingData;
        otherwise
            error('Unknown task!');
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

    if mode.inspectDesign_on
    Display('Please make sure that this design is correct. Insert `dbcont` to continue, or `dbquit` to abort');

    %% exp begins
    %keyboard;
end

    if exist('./data', 'dir') ~= 7
        mkdir('data');
    end
    if exist(['data/' render.dataPrefix], 'dir') ~= 7
        mkdir(['data/' render.dataPrefix]);
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
    if exist('Subinfo','var');data.Subinfo = Subinfo'; else data.Subinfo = getSubInfo(mode.debug_on)';end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% initialization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    try
    % only use try for the Psychtoolbox part

    HideCursor;
    ListenChar(2);

    % used now; used during OpenScreen
    render.backgroundColor = conf.color.backgroundColor;
    [w, render] = initScreen(render, mode.debug_on);
    set_test_gamma;
    Screen('FillRect', w, 67*[1 1 1]);

    if render.ifi > conf.flpi + 0.0005 % allow 0.5ms error
        error('HardwareError:MonitorFlushRate',...
            'Monitor Flip Interval is too large. Please adjust monitor flush rate \n from system preferences, or adjust conf.flpi fron test.m file.');
    end
    Priority(MaxPriority(w));

    HideCursor;

    Screen(w,'TextStyle',0);
    Screen('Preference', 'TextRenderer', 1);
    Screen('Preference', 'TextAntiAliasing', 1);
    Screen('TextFont', w, 'Microsoft Simsun'); % or `Microsoft Simsun`?
    Screen('TextSize', w, 20); % ziti size





    %% Instructions
    DrawFormattedText(w, instrDB(render.task, mode.english_on), 'center', 'center', conf.color.textcolor);
    % FIXME: something wrong is here above
    Screen('Flip', w);
    if mode.recordImage; recordImage(1,1,[render.task '_instr'],w,render.wsize);end
    %if ~mode.debug_on;Speak(sprintf(instrDB(render.task, mode.english_on)));end
    KbWait;



    flow.nresp    = 1;  % the total number of response recorded
    flow.restcount= 0;  % the number of trials from last rest
    flow.trialID = 1;
    flow.Q = {}; % blockID type, Quest Q, tTestLast, measureLast
    %% Here begins our trial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%眼动相关
%commandwindow;
if mode.eyetracking_mode == 1
numOfBlock = 1;
dummymode=0;
showboxes=1;
el=EyelinkInitDefaults(w);
if ~EyelinkInit(dummymode, 1)
    fprintf('Eyelink Init aborted.\n');
    cd(CurrDir);
    abort(CurrDir);
end
Eyelink('Command', 'set_idle_mode');
Eyelink('Command', 'clear_screen 0')
Eyelink('command','draw_box %d %d %d %d %d',1024/2-17, 768/2-17, 1024/2+17, 768/2+17,15);
Eyelink('command','draw_cross %d %d %d',1024/2,768/2,8);
[v vs]=Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );
% make sure that we get event data from the Eyelink
% Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
Eyelink('command', 'link_event_data = GAZE,GAZERES,HREF,AREA,VELOCITY');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,BLINK,SACCADE,BUTTON');
 
% open file to record data to
edfFile=[data.Subinfo{2} num2str(numOfBlock) '.edf'];
Eyelink('Openfile', edfFile);       
% STEP 4
% Calibrate the eye tracker
EyelinkDoTrackerSetup(el);
 
% STEP 6
% do a final check of calibration using driftcorrection
success=EyelinkDoDriftCorrection(el);
if success~=1
    cd(CurrDir);
    abort(CurrDir);
end
Screen('Flip',  w, [], 1); % don't erase buffer
eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
if eye_used == el.BINOCULAR; % if both eyes are tracked
    eye_used = el.LEFT_EYE; % use left eye
end
end 
    
    while true
        % only ends when ALL trials have collected correct response
        % see recordResponse()

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% data generatoin
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % initialization
        [data.Trials(flow.nresp, :) flow.Q]= tunnelUpdate(mode.procedureChannel, conf, data.Trials(flow.nresp, :), flow.Q, data.Trials(:,2));

        [data.draw, render] = genData(data.Trials(flow.nresp, :), render, conf);
        flow.tPresented = render.tPresented;

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
        if mode.eyetracking_mode == 1
        [flow.restcount numOfBlock]= restBetweenTrial(flow.restcount, getTime('RestBetweenBlocks', mode.debug_on), conf.restpertrial, w, render.wsize, mode.debug_on, mode.english_on, render.kb, 1, mode.serialInput_on, mode.eyetracking_mode, numOfBlock, render, data);
        else
        [flow.restcount numOfBlock]= restBetweenTrial(flow.restcount, getTime('RestBetweenBlocks', mode.debug_on), conf.restpertrial, w, render.wsize, mode.debug_on, mode.english_on, render.kb, 1, mode.serialInput_on);
        end
        % NOTE: do we need wait black screen between Trials, random?
        WaitSecs(getTime('WaitBetweenTrials', mode.debug_on));  % wait black screen between Trials, random

        if mode.recordImage; recordImage(1,1,[render.task '_mirror'],w,render.wsize); end


        Screen('FillRect',w, conf.color.backgroundColor);
        render.vlb = Screen('Flip', w);  % record render.vlb, used for TIMING control



        %% now prsent Stim that you can see on the screen
        % show fixation
        data.drawFix.fix = data.draw.fix; % copy out the fixation in the stimuli
        data.drawedFix(flow.nresp) = drawObjects(w, render, data.drawFix); % only the fix part
        if mode.persistentFix == 1
        data.constantCircle.circle = data.draw.constant.circle;
        if mode.drawBlackCircle == 1
        data.drawedConstantCircle(flow.nresp) = drawObjects(w, render, data.constantCircle); % only the circle part
        end
        end
        if mode.eyetracking_mode == 1
        Eyelink('Message','Trial %d Begin', flow.nresp);
        end
        Screen('Flip', w);
        WaitSecs(data.Trials(flow.nresp, 4));

        % present stimuli
        data.drawed = drawObjects(w, render, data.draw);
        if mode.eyetracking_mode == 1
        %开始记录
        Eyelink('startrecording'); 
        end
        Screen('Flip', w);
        %render.vlb = Screen('Flip', w, render.vlb + (1-0.5)*conf.flpi);%use the center of the interval
        % Flip the visual stimuli on the screen, along with timing
        % old = render.vlb;
        if mode.recordImage; recordImage(1,1,render.task ,w,render.wsize);end

        % get the response
        flow.onset = GetSecs();
        if strcmp(render.task, 'CrowdingTask')
        [flow.rt flow.response flow.respTime] = collectResponse(conf.validKeys(2:end), data.Trials(flow.nresp,18), flow.onset); 
        if mode.eyetracking_mode == 1
        Eyelink('stoprecording');
        end
        else
        [flow.rt flow.response flow.respTime] = collectResponse(conf.validKeys(2:end), getTime('TrialDuration', mode.debug_on), flow.onset); % first one is space
        end
        % also record here if the subject have not responded yet

        if strcmpi(flow.response, 'DEADLINE')
            Display('Please respond! We are still collecting data!');
        Screen('FillRect',w, conf.color.backgroundColor);
        if mode.persistentFix == 1
            data.drawedFix(flow.nresp) = drawObjects(w, render, data.drawFix); % only the fix part
        end
        render.vlb = Screen('Flip', w);  % record render.vlb, used for TIMING control
        if strcmp(render.task, 'CrowdingTask')
            getTimeStr = 'CrowdingBlankAfterResp';
        else
            getTimeStr = 'BlankAfterResp';
        end
        [flow.rt flow.response flow.respTime] = collectResponse(conf.validKeys(2:end), getTime(getTimeStr, mode.debug_on), flow.onset); % first one is space
        %WaitSecs(getTime('BlankAfterResp', mode.debug_on));
    end

        % Display(flow.response);
        switch flow.response
            case {'Escape', 'escape'}
                flow.isquit = 1;
                manualAbort();

            case conf.validKeys(3:end) % all stimuli (first two are space and escape)
                % NOTE: here assuming that conf.validKeys have space, escape as the first two
                flow.idxResponse = find(strcmpi(conf.validKeys, flow.response))-2;

                % record response
                [data, flow] = recordResponse(flow, data, conf);

                if mode.feedback_on
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
        if mode.persistentFix == 1
            data.drawedFix(flow.nresp) = drawObjects(w, render, data.drawFix); % only the fix part
        end
        WaitSecs(getTime('BlankAfterTrial', mode.debug_on));
        Screen('Flip', w);



        % do exactly once_on times
        %mode.once_on = mode.once_on-1;
        %if ~mode.once_on; flow.isquit = 1;warning('Preparation Finished! (No worries. This is no bug, buddy.)'); end


        %Display(flow.isquit)
        if flow.isquit
            % End of experiment
            break
        end;

    end % while true
if mode.eyetracking_mode == 1
%眼动结束
% End of Experiment; close the file first, close graphics window, close data file and shut down tracker
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.5);
    Eyelink('CloseFile');
    
    % download data file
    try
        if numOfBlock ~=1
            edfFile = [data.Subinfo{2} num2str(numOfBlock) '.edf'];
        end
        fprintf('Receiving data file ''%s''\n', edfFile );
        status=Eyelink('ReceiveFile');
        if status > 0
            fprintf('ReceiveFile status %d\n', status);%status 为文件大小，这句将返回文件大小，0表示传输过程被取消，负值表示错误代码
       end
        if 2==exist(edfFile, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
        end
    catch 
        fprintf('Problem receiving data file ''%s''\n', edfFile );
    end
end



    disp('');
    Display('data/latest.mat saved successfully, use for debugging!');
    disp('');
    data.stat = analyzeData(data);
    render.matFileName = ['data/',render.dataPrefix, data.Subinfo{1} , render.dataSuffix, tunnelSelection(mode.procedureChannel), datestr(now, 'yyyymmddTHHMMSS'), '.mat'];
    save(render.matFileName,'conf','flow','mode','data','render');
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
    disp('');
    Display('data/buggy.mat saved successfully, use for debugging!');
    disp('');
    render.matFileName = ['data/',render.dataPrefix, data.Subinfo{1} , render.dataSuffix, tunnelSelection(mode.procedureChannel), datestr(now, 'yyyymmddTHHMMSS'), 'buggy.mat'];
    save(render.matFileName);
    wrkspc = load(render.matFileName);
    %     disp(['';'';'data/buggy saved successfully, use for debugging!']);
    RestoreCluts;
    Screen('CloseAll');
    %if mode.audio_on; PsychPortAudio('Close'); end
    Priority(0);
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
    Screen('Preference', 'Verbosity', 3);
    format short;
end

%% exp ends
RestoreCluts;
Screen('CloseAll');
%if mode.audio_on; PsychPortAudio('Close'); end
Priority(0);
ShowCursor;
ListenChar(0);
Screen('Preference', 'Verbosity', 3);

% always save the latest data for the last experiment
save data/latest.mat;
Display(char('','','data/latest.mat saved successfully, use for testing!',''));
%figure;
%boxplot(Trials(:,3),Trials(:,2));
%title([data.Subinfo{1} ':' render.task]);
%format short;
Display('Experiment was successful!');
end
