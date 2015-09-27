function Trials = genCrowdingSequence(conf, mode)
%GENTRIALCONDITIONS generates stimulus data and experiment settings based on `conf` struct
%
% We cannot have seperate QUEST sequences that measures thresholds for
% different variables in a single run of experiment, since that could
% complicate experiment. For example, we could measure the distance between the
% fixation to the target, and the spacing between the flankers and the target.
% These two variables both could capture the spatial profile of crowding. But,
% since they are both continuous variables, we should be using a
% two-dimentional QUEST to get the contour curves rather than blindly adjusting
% around using one-dimentional QUEST that we have now. So, we should always
% only measure one varibale using QUEST.
%
% That being said, we can still have several QUEST sequences under different
% discrete conditions for the same variable. For example, we could change the
% shape of the target so the salience is controlled under different levels,
% fixate the distance between fixation and the target (eccentricity), then
% measure the threshold for flanker spacing; or fixate spacing and measure
% eccentricity. 
%
% As for implementation, we could only have one variable that specifies the
% procedure (for example "QUEST"), and all others could be generated. However,
% "Constant" and one adaptive method could be used simultenously for generating
% several sequences at the same time. For example, if the Shepe is "Constant"
% and flanker distance is quest, then several sequences of QUEST is generated
% for measuring threshold flanker distance for each level conbination of
% constants. Variables that specify constant should also provide the levels.
%
%
%
% SYNOPSIS: data = genSequence(nBlocks, nTrials, nStims)
%
% INPUT
%
%
%
% OUTPUT data
%       data.Trials is the output. This is a big table, each column representing a different variable. Here we implement ѕynamic generation; to be able to interface with standard psychophysics methods such as QUEST. *negative* integers in the variable field (such as those idx* will use different procudure to generate the random number for the next trials based on the data from last few trials). Refer to channelSelection() to see the negative integers and the specific method that is to be used.
%
%	Column 1
%	    trialN
%	    To be recorded.
%	Column 2
%	    blockID
%	    To be recorded.
%	Column 3
%	    trialID
%	    To be recorded.
%	Column 4
%	    fixDuration
%	Column 5
%	    idxTargetDist (major)
%	Column 6
%	    idxTargetColor (balance)
%	Column 7
%	    idxFlankerDist (major)
%	Column 8
%	    idxFlankerColor (balance)
%	Column 9
%	    crossCoor
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
%	Column 16
%	    idxTargetShape  (balance)
%

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 企业版 Version 6.3 (Build 9600)
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
nColumns = 16;

[whichProcedure codeProcedure]= lower(channelSelection(mode.procedureChannel));
switch 
    case {'Constant', 'constant'}

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

case {'QUEST' , 'quest'}
    % we use the QUEST procedure here!


case {'nUp1Down' , 'nup1down'}
    % we use the nUp1Down (N-up-1-down) procedure here!


otherwise
    error('genCrowdingSequence:unknownProcedure', 'procedure %s is unknown!');
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
Trials(:, 9) = ((rand(size(Trials,1),1)>conf.highRewardLevel) & (Trials(:, 6) == Trials(:, 8))) + ((rand(size(Trials,1),1)<(1-conf.highRewardLevel)) & (Trials(:, 6) ~= Trials(:, 8)));


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

%	Column 16~22
%	    idxDistractorColor
Trials(:, 16:16+conf.nStims-1) = Shuffle(repmat(1:conf.nStims, size(Trials, 1), 1)')';

%	Column 23~27
%	    idxDistractorBar
Trials(:, 23:23+conf.nStims-1) = Randi(numel(conf.distractorOrientations), [size(Trials,1), conf.nStims]);

if mode.once_on > 0
    Trials = Trials(1:mode.once_on, :);
end
end
