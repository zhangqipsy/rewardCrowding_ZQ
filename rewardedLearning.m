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
% on Microsoft Windows 8.1 企业�?Version 6.3 (Build 9600)
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

addpath('./data', './lib', './resources');
data=struct();

% input variables, use them via updateStruct() to update the defined variables below
% these conf, mode was defined through wrapper shells such as DirectionTask
if nargin > 0
    render.conf=conf;
    render.mode=mode;
end

% conf and mode variables listed here for using calling from a WRAP FUNCTION
% so do not directly change any value here!

% time setting vatiables
conf.flpi               =  .02;         % each frame is set to 20ms (the monitor's flip interval is 16.7ms)
conf.trialdur           =  70;          % duration time for every trial
conf.repetitions        =  5;           % repetition time of a condition
conf.resttime           =  30;          % rest for 30s
conf.waitBetweenTrials  =  .8+rand*0.2; % wait black screen between Trials, random
conf.waitFixationScreen =  .8+rand*0.2; % '+' time randomized
conf.restpertrial       =  1;           % every x trial a rest
conf.nStims              =  8;           % how many PLWs to draw on screen in a circle
conf.clockR             =  .75;         % clock, with the center of the screen as (0,0), in pr coordination system
conf.scale1             =  20;          % PLW's visual scale, more the bigger
conf.backgroundColor = [128 128 128];
conf.freq = 48000;

% evaluate the input arguments of this function
% state control variables
mode.demo_on        = 0;  % baseline trial, without visual stimuli
mode.colorbalance_on = 1; % balance the colors by oneself
mode.english_on         = 1;  % use English for Instructions etc., 0 for Chinese(not supported for now!)
% DO NOT CHANGE UNLESS YOU KNOW EXCACTLY WHAT YOU ARE DOING
mode.regenerate_on      = 1;  % mode.regenerate_on data for experiment, rather than using the saved one
mode.RT_on              = 0;  % Reaction time mode, this is not to be changed!
mode.usekb_on           = 0;  % force use keyboard for input (also suppress output from digitalIO)
mode.debug_on           = 1;  % default is 0; 1 is not to use full screen, and skip the synch test
mode.recordImage        = 0;  % make screen capture and save as images; used for post-hoc demo

% evaluate the input arguments of this function
if nargin > 0
    conf = updateStruct(render.conf, conf);
    mode = updateStruct(render.mode, mode);
end



render.dataPrefix=[];
render.dataSuffix=[];
if mode.demo_on
    render.dataPrefix = ['Demo/'];
    render.dataSuffix = [dataSuffix '_RawardDemo_'];
    render.task = 'RawardDemo';
else
    render.dataPrefix = ['RewardTask/'];
    render.dataSuffix = [dataSuffix '_RawardTask_'];
    render.task = 'RawardTask';
end

switch mode.colorbalance_on
    case 1
        % auto-balance the color
        if round(rand)
            flipud(conf.colors);
            dataSuffix = [dataSuffix '_greenTarget_'];
            data.isRedHigh = 1;
        else
            dataSuffix = [dataSuffix '_redTarget_'];
            data.isRedHigh = 1;
        end
        dataSuffix = [dataSuffix '_ColorBalance_'];
end

if mode.RT_on
    conf.restpertrial       =  inf;           % every x trial a rest
end

seqChoice = genTrialConditions(8, 100, 6);  % for predicted altruism
[flow.Trialsequence, Trials] = genTrial(conf.repetitions, 9, [1, 4]);
Display(designChoice);
Display('Please make sure that this design is correct. Insert `dbcont` to continue, or `dbquit` to abort');

%% exp begins
keyboard;


try
    if exist('./data', 'dir') ~= 7
        mkdir('data');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Hardware/Software Check
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mode.recordImage = 0;

    % make sure the software version is new enouch for running the program
    checkVersion();

    % unified key definitions
    render.kb = keyDefinition();

    % psychoaudio hardware setting.
    if mode.audio_on
        conf.freq = 48000;
        pahandle = loadAutio(freq);
    end

    % Get Subject information
    if ~exist('Subinfo','var');data.Subinfo = getSubInfo();end


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
        [w,render.wsize]=Screen('OpenWindow',render.screenNumber,0,[1,1,801,601],[]);
    else
        [w,render.wsize]=Screen('OpenWindow',render.screenNumber,0,[],32);
    end
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);



    render.ifi=Screen('GetFlipInterval', w);
    if render.ifi > conf.flpi + 0.0005 % allow 0.5ms error
        error('HardwareError:MonitorFlushRate',...
            'Monitor Flip Interval is too large. Please adjust monitor flush rate \n from system preferences, or adjust conf.flpi fron *Task.m file.');
    end
    Priority(MaxPriority(w));

    HideCursor;

    Screen(wptr,'TextStyle',0);
    Screen('Preference', 'TextRenderer', 1);
    Screen('Preference', 'TextAntiAliasing', 1);
    Screen('TextFont', wptr, 'Microsoft Simsun'); % or `Microsoft Simsun`?
    Screen('TextSize', wptr, 20); % ziti size

    render.cx = render.wsize(3)/2; %center x
    render.cy = render.wsize(4)/2; %center y


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% data generatoin
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data = genData(conf, render);


    flow.nresp    = 1;  % the total number of response recorded
    flow.restcount= 0;  % the number of trials from last rest


    %% Instructions
    DrawFormattedText(w, instrDB(render.task, mode.english_on), 'center', 'center', [255 255 255 255]);
    Screen('Flip', w);
    if mode.recordImage; recordImage(1,1,[render.task '_instr'],w,render.wsize);end
    %if ~mode.debug_on;Speak(sprintf(instrDB(render.task, mode.english_on)));end
    pedalWait(mode.tactile_on, inf, render.kb);


    %% Here begins our trial
    for k = 1:length(flow.Trialsequence)
        %      tic;
        flow.prestate = 0;  % the last reponse until now
        flow.response = 0;  % the current current response, just after the last response


        flow.Trial = k;
        % rest every couple trials once
        if flow.Trial > 1
            WaitSecs(0.001);
            showLeftTrial(flow.Trialsequence, flow.Trial, w, render.wsize, mode.debug_on, mode.english_on, render.kb, 1, mode.tactile_on);
            if mode.recordImage; recordImage(1,1,[render.task '_remaining'],w,render.wsize);end
        end

        flow.restcount = restBetweenTrial(flow.restcount, conf.resttime, conf.restpertrial, w, render.wsize, mode.debug_on, mode.english_on, render.kb, 1, mode.tactile_on);
        conf.waitBetweenTrials  =  .8+rand*0.2; % wait black screen between Trials, random


        WaitSecs(conf.waitBetweenTrials);  % wait black screen between Trials, random


        if mode.recordImage; recordImage(1,1,[render.task '_mirror'],w,render.wsize); end


        Screen('FillRect',w, conf.backgroundColor);
        render.vlb = Screen('Flip', w);  % record render.vlb, used for TIMING control

        %% PLW that you can see on the screen
        flow.isquit = 0;     % to capture ESCAPE for quitting
        flow.isresponse = 0;
        render.iniTimer=GetSecs;

        data.iniTactile = data.tTrack(find(data.tTrack>0,1));%initial type of tactile stimuli
        if isempty(data.iniTactile);
            data.iniTactile = 0;  %baseline is 0
        end

        for i=data.Track  %loop leghth
            flow.Flip = i;
            if mode.mirror_on
                % we do not need noise for mask here!
            else
                % here comes the noise background
                %addNoise(w, 256, render.wsize);%Do not use this, since buffer tex is used
                Screen('DrawTexture', w, tex(render.noiseloop(flow.Flip)), [], render.dstRect, [], 0);
            end


            Screen('DrawingFinished', w); % no further drawing commands will follow before Screen('Flip')

            %Here comes the sound
            if mode.audio_on
                playSound(pahandle, freq, data.paceRate, data.moveDirection(flow.Trial, 1));
            end


            % get the response

            % Flip the visual stimuli on the screen, along with timing
            % old = render.vlb;
            render.vlb = Screen('Flip', w, render.vlb + (1-0.5)*conf.flpi);%use the center of the interval
            if mode.recordImage; recordImage(flow.Flip,10,render.task ,w,render.wsize);end
            %        toc;
            %        tic;
        end

        % end of per trial
        Screen('Flip', w);



        % do exactly once_on times
        mode.once_on = mode.once_on-1;
        if ~mode.once_on; error('Preparation Finished! (No worries. This is no bug, buddy.)'); end
    end;

    % End of experiment


    Display(char('','','data/latest.mat saved successfully, use for debugging!',''));
    render.matFileName = ['data/',dataPrefix, Subinfo{1} , dataSuffix, date, '.mat'];
    save(render.matFileName,'Trials','conf', 'Subinfo','flow','mode','data');
    wrkspc = load(render.matFileName);
    Display(render.matFileName);
    % Display 'Thanks' Screen
    if true
        RL_Regards(w, mode.english_on);
    else
        % not end yet
        % do the following test here
    end

catch
    % always save the buggy data for debugging
    save data/buggy.mat;
    Display(char('','','data/buggy.mat saved successfully, use for debugging!',''));
    save(['data/', dataPrefix, Subinfo{1}, dataSuffix, date, 'buggy.mat']);
    wrkspc = load(['data/', dataPrefix, Subinfo{1}, dataSuffix, date, 'buggy.mat']);
    %     disp(['';'';'data/buggy saved successfully, use for debugging!']);
    Screen('CloseAll');
    if mode.audio_on; PsychPortAudio('Close'); end
    Priority(0);
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
    format short;
end

%% exp ends
Screen('CloseAll');
if mode.audio_on; PsychPortAudio('Close'); end
Priority(0);
ShowCursor;
ListenChar(0);

% always save the latest data for the last experiment
save data/latest.mat;
figure;
%boxplot(Trials(:,3),Trials(:,2));
%title([Subinfo{1} ':' render.task]);
%format short;
Display('Experiment was successful!');

end
