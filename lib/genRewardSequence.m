function Trials = genRewardSequence(conf, mode)
%GENTRIALCONDITIONS generates stimulus data and experiment settings based on `conf` struct
%
% SYNOPSIS: data = genSequence(conf, mode)
%
% INPUT
%
%
%
% OUTPUT data
%       data.Trials is the output. This is a big table, each column
%       representing a different variable.
%	Column 1
%	    trialN
%	    To be recorded.
%	Column 2
%	    blockID (in trial-by-trial experiments that uses adaptive stimulation
%	    methods such as QUEST, different blockID represents different sequence)
%	    To be recorded.
%	Column 3
%	    trialID
%	    To be recorded.
%	Column 4
%	    fixDuration
%	Column 5
%	    idxTargetPosition
%	Column 6
%	    idxTargetColor
%	Column 7
%	    idxTargetBar
%	Column 8
%	    idxHighRewardColor
%	Column 9
%	    isHighReward
%	Column 10
%	    respType
%	    To be recorded.
%	Column 11
%	    respRT
%	    To be recorded.
%	Column 12
%	    respTime
%	    To be recorded.
%	Column 13
%	    isCorrect
%	    To be recorded.
%	Column 14
%	    counterTillCorrect
%	    To be recorded.
%	Column 15
%	    rewardAmount
%	    To be recorded.
%	Column 16~21
%	    idxDistractorColor
%	Column 22~27
%	    idxDistractorBar
%

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 ∆Û“µ∞Ê Version 6.3 (Build 9600)
%
% Author: Hormet, 2015-08-31
% UPDATED: 2015-08-31 16:55:41
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
nColumns = 28;
if conf.repetitions == 0
    Trials = NaN(conf.totalTrials, nColumns);
    [Trials(:,4) Trials(:,5) Trials(:,6) Trials(:,7)] = BalanceTrials(conf.totalTrials, 1, conf.fixLevels, conf.nStims, numel(conf.color.targets), conf.targetOrientations);
if mode.demo_on
 minTrials = prod([numel(conf.fixLevels), conf.nStims, conf.nTargets, numel(conf.targetOrientations)]);
    [Trials(:,4) Trials(:,5) Trials(:,6) Trials(:,7)] = BalanceTrials(minTrials, 1, conf.fixLevels, conf.nStims, numel(conf.color.targets), conf.targetOrientations);
end

else
[Trialsequence, Trials] = genTrial(conf.repetitions, nColumns, [numel(conf.fixLevels), conf.nStims, numel(conf.color.targets), numel(conf.targetOrientations)]);
if mode.demo_on
    [Trialsequence, Trials] = genTrial(1, nColumns, [numel(conf.fixLevels), conf.nStims, numel(conf.color.targets), numel(conf.targetOrientations)]);
end
%	Column 4
%	    fixDuration
%	Column 5
%	    idxTargetPosition
%	Column 6
%	    idxTargetColor
Trials(:, [4 5 6 7]) = Trialsequence;
Trials(:, 4) = Replace(Trials(:,4), 1:numel(conf.fixLevels), conf.fixLevels);
end


%	Column 8
%	    idxHighRewardColor
%	Column 9
%	    isHighReward
Trials(:, 8) = conf.idxHighRewardColor; % see conf.color.targets for idx used
randSequence = rand(size(Trials, 1),1);
keyboard
Trials(:, 9) = ((randSequence>conf.highRewardLevel) & (Trials(:, 6) == Trials(:, 8))) + ((randSequence<(1-conf.highRewardLevel)) & (Trials(:, 6) ~= Trials(:, 8)));


%	Column 14
%	    counterTillCorrect
%	    To be recorded.
%	Column 15
%	    rewardAmount
%	    To be recorded.
%
%	    initialize here
Trials(:, 14) = zeros(size(Trials,1), 1);
Trials(:, 15) = zeros(size(Trials,1), 1);

%keyboard
%	Column 16~21
%	    idxDistractorColor
Trials(:, 16:16+conf.nStims-1) = Shuffle(repmat(1:conf.nStims, size(Trials, 1), 1)')';

%	Column 22~27
%	    idxDistractorBar
Trials(:, 22:22+conf.nStims-1) = Randi(numel(conf.distractorOrientations), [size(Trials,1), conf.nStims]);

if mode.once_on > 0
    Trials = Trials(1:mode.once_on, :);
end
end
