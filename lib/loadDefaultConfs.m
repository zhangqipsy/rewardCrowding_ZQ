function [conf, mode] = loadDefaultConfs()
%LOADDEFAULTCONFS loads all the default values for the experiment, which would normally be overwritten by the shell wrapper.
%
% SYNOPSIS: [cond, mode] = loadDefaultConfs()
%
% INPUT
%			No arguments should be given!
%
% OUTPUT [cond
%		mode]
%

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 企业�?Version 6.3 (Build 9600)
%
% Author: Hormet, 2015-08-31
% UPDATED: 2015-08-31 16:04:17
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

% evaluate the input arguments of this function
% state control variables
mode.demo_on        = 0;  % baseline trial, without visual stimuli
mode.colorBalance_on = 0; % 0 for auto balance (rand); 1, 2 for idxHighRewardColor
mode.audio_on       = 1;
mode.speak_on       = 1;
mode.english_on         = 1;  % use English for Instructions etc., 0 for Chinese(not supported for now!)
mode.linearStim_on  = 0;
mode.procedureChannel = 0; % experiment methods;
                            %'Constant',  0
                            %'QUEST',    -1
                            %'nUp1Down', -2
mode.inspectDesign_on = 1; % see experiment design before starting the experiment

% DO NOT CHANGE UNLESS YOU KNOW EXCACTLY WHAT YOU ARE DOING
mode.regenerate_on      = 1;  % mode.regenerate_on data for experiment, rather than using the saved one
mode.tillResponse_on    = 1;  % flip after catching response
mode.usekb_on           = 0;  % force use keyboard for input (also suppress output from digitalIO)
mode.debug_on           = 1;  % default is 0; 1 is not to use full screen, and skip the synch test
mode.recordImage        = 0;  % make screen capture and save as images; used for post-hoc demo
mode.serialInput_on     = 0;  % serial input devices
mode.once_on            = 0;  % end of experiment after these many trials




% experiment configuration vatiables
conf.repetitions        =  1;           % repetition time of a condition
% NOTE: usign totalTrials requireѕ knowledge of the code; therefore it is NOT RECOMMENDED
% simply use repetition
conf.totalTrials        = 1008;     % respects this if repititions is zero
conf.restpertrial       =  100;           % every x trial a rest
conf.showLeftTrialsEvery     = 5;
conf.nStims              =  6;          % number of stimuli (target+distractors) present in each trial/throughout the experiment
conf.nUp1DownParams     = [3 40 ] ;
conf.QUESTparams        = [0.1 40  0.1]; % FIXME: dunno what it means
conf.nTargets           = 1;            % number of targets present in each trial/throughout the experiment
conf.audioFreq = 44100;                 
conf.fixLevels          = [.4 .5 .6];
conf.idxHighRewardColor = 1;        
conf.highRewardLevel    = .2;
conf.rewardAmounts      = [0.1 0.5];
conf.targetOrientations = [0 pi/2];
conf.distractorOrientations = [pi/4 -pi/4];
conf.validKeys          = {'space', 'escape', 'z', 'm'}; % always keep espace and space in this order!
conf.audioTone1Hz   = 1000;
conf.audioTone2Hz   = 500;
conf.flpi               = .02;          % NOTE:  NOT used

% NOTE: check this values out!
conf.monWidth   = 38.5;
conf.viewDist       = 75;
conf.cmPerPix = conf.monWidth/1024;

%BlkNum_Learn = 7; TrlNumPerBlk_Learn = 120;TrlNumPerBlk_LearnPrac = 48;Split = 4.8;
%ColorPatchTime_Learn = 0.6; waitTimeForResp_Learn = 1; ValH = 'b';ValL ='r';ValCon ='g';%0.6
%monWidth = 38.5; viewDist = 75;cmPerPix = monWidth/1024;makeSti;Split = round(DegreesToRetinalMM(Split,viewDist)/cmPerPix); %120 trl


% NOTE: these color values folow the original code by Li Ya from Sheng Li lab at PKU; as for the reason for the chosen values, it remains to be investigated; or in short, as her why she chose these colors.

% targets
color.red = [211 0 0];
color.green = [0 95 0];
color.targets = {color.red, color.green};
color.black = [0 0 0];
color.white = [255 255 255];
% distractors
color.blue = [0 50 255];
color.cyan = [0 83 83]; 
color.pink = [131 37 84];
color.orange = [123 53 11];
color.yellow = [67 74 0];
color.lightpurple = [74 47 157]; % NOTE: this color could be too strong/light!
color.distractors = {color.blue ,color.cyan ,color.pink ,color.orange ,color.yellow ,color.lightpurple};


% other colors
color.gray = [67 67 67];
color.backgroundColor = [67 67 67];% background color=black
color.barcolor = 180;
color.textcolor = 256*[1 1 1]; % used for instruction
color.textcolor2 = [40 40 40]; % used for feedback

color.bar = color.black;
color.fix = color.white;

conf.color = color;


% Parameter in degree
range_r     = 5;   % radius of imaginary circle(deg)
bar_r       = 0.76;  % length (diameter) of the bar(deg)
bar_r2     = 0.08;  % width (diameter) of the bar(deg)
cir_r       = 2.3/2;  % deg of circle (deg)
fix_r       = 0.25; % long arm radius of fixation cross (deg)
fix_r2    = 0.03; % short arm radius of fixation cross (deg)


% Parameter in pix
metric.range_r     = round(DegreesToRetinalMM(range_r,conf.viewDist)/conf.cmPerPix);   % radius of imaginary circle(pix)
metric.bar_r       = round(DegreesToRetinalMM(bar_r,conf.viewDist)/conf.cmPerPix);  % longitude (diameter) of the bar(pix)
metric.bar_r2       = round(DegreesToRetinalMM(bar_r2,conf.viewDist)/conf.cmPerPix);  % width (diameter) of the bar(pix)
metric.cir_r       = round(DegreesToRetinalMM(cir_r,conf.viewDist)/conf.cmPerPix);  % deg of circle (pix)
metric.fix_r       = round(DegreesToRetinalMM(fix_r,conf.viewDist)/conf.cmPerPix); % long arm radius of fixation cross (pix)
metric.fix_r2    = round(DegreesToRetinalMM(fix_r2,conf.viewDist)/conf.cmPerPix); % short arm radius of fixation cross (pix)
metric.circle_width = 3.35;
scale             =  1;          % linear magnifier

metric = structfun(@(x) scale*x, metric, 'UniformOutput', false);
metric.scale = scale;

conf.metric = metric;



end
