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
% on Microsoft Windows 8.1 ��ҵ�� Version 6.3 (Build 9600)
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
% DO NOT CHANGE UNLESS YOU KNOW EXCACTLY WHAT YOU ARE DOING
mode.regenerate_on      = 1;  % mode.regenerate_on data for experiment, rather than using the saved one
mode.tillResponse_on    = 1;  % flip after catching response
mode.usekb_on           = 0;  % force use keyboard for input (also suppress output from digitalIO)
mode.debug_on           = 1;  % default is 0; 1 is not to use full screen, and skip the synch test
mode.recordImage        = 0;  % make screen capture and save as images; used for post-hoc demo



% experiment configuration vatiables
conf.repetitions        =  13;           % repetition time of a condition
conf.totalTrials        = 1008;     % respects this if repititions is zero
conf.restpertrial       =  100;           % every x trial a rest
conf.nStims              =  6;          % number of stimuli (target+distractors) present in each trial/throughout the experiment
conf.nTargets           = 1;            % number of targets present in each trial/throughout the experiment
conf.audioFreq = 1000;
conf.fixLevels          = [.4 .5 .6];
conf.idxHighRewardColor = 1;        
conf.highRewardLevel    = .8;
conf.targetOrientations = [0 90];
conf.distractorOrientations = [45 135];

% NOTE: check this values out!
conf.viewDist       = 50;
conf.cmPerPix   = .1;


% NOTE: these color values folow the original code by Li Ya from Sheng Li lab at PKU; as for the reason for the chosen values, it remains to be investigated; or in short, as her why she chose these colors.

% targets
color.red = [106 0 0];
color.green = [0 60 0];
color.targets = {color.red, color.green};

% distractors
color.blue = [0 0 95];
color.cyan = [0 255 255]; % NOTE: this color could be too strong/light!
color.pink = [106   12    59];%[230 55 125 ]; %��Ϊgreen
color.orange = [115  54  3];
color.yellow = [96   101  0];%[130 131 50];  % 110    45     0 [   101    22     0];
color.white = [255 255 255]; % NOTE: this color could be too strong/light!
color.distractors = {color.blue ,color.cyan ,color.pink ,color.orange ,color.yellow ,color.white};


% other colors
color.lightpurple = [74 47 157];%;[ 0    26  11];[150 118 115] %NOTE: this color was not present in the original paper
color.gray = [74 92 82];%[123 79 255]; [196 5 230]%NOTE: this color was not present in the original paper
color.backgroundColor = [128 128 128];% background color=black
color.barcolor = 180;
color.textcolor = [90 90 90];
color.textcolor2 = [40 40 40];

conf.color = color;


% Parameter in degree
range_r     = 4.8;   % radius of imaginary circle(deg)
bar_r       = 1.5;  % length (diameter) of the bar(deg)
bar_r       = 1.5;  % length (diameter) of the bar(deg)
bar_r2     = 0.08;  % width (diameter) of the bar(deg)
bar_r2     = 0.08;  % width (diameter) of the bar(deg)
cir_r       = 2.5/2;  % deg of circle (deg)
fix_r       = 0.25; % long arm radius of fixation cross (deg)
fix_r2    = 0.03; % short arm radius of fixation cross (deg)


% Parameter in pix
metric.range_r     = round(DegreesToRetinalMM(range_r,conf.viewDist)/conf.cmPerPix);   % radius of imaginary circle(pix)
metric.bar_r       = round(DegreesToRetinalMM(bar_r,conf.viewDist)/conf.cmPerPix);  % longitude (diameter) of the bar(pix)
metric.bar_r2       = round(DegreesToRetinalMM(bar_r2,conf.viewDist)/conf.cmPerPix);  % width (diameter) of the bar(pix)
metric.cir_r       = round(DegreesToRetinalMM(cir_r,conf.viewDist)/conf.cmPerPix);  % deg of circle (pix)
metric.fix_r       = round(DegreesToRetinalMM(fix_r,conf.viewDist)/conf.cmPerPix); % long arm radius of fixation cross (pix)
metric.fix_r2    = round(DegreesToRetinalMM(fix_r2,conf.viewDist)/conf.cmPerPix); % short arm radius of fixation cross (pix)
metric.scale1             =  20;          % linear magnifier
metric.circle_width = 3.35;

conf.metric = metric;



end
