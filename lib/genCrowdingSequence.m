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
%	    this controls the adaptive sequence!
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
%	    idxFlankerDist (major[default in test.m])
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
%	Column 17
%	    idxDistractorShape  (balance)

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 企业�?Version 6.3 (Build 9600)
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
nColumns = 17;

% let's only use this before BalanceTrials is ready
[Trialsequence, Trials] = genTrial(conf.repetitions, nColumns, [ ...
    numel(conf.fixLevels), ...
    conf.nStims, ...
    numel(conf.color.targets), ...
    numel(conf.deg.targetDist), ...
    numel(conf.deg.range_r), ...
    numel(conf.color.distractors), ...
    numel(conf.targetShapes), ...
    numel(conf.distractorShapes) ...
    ]);


%	Column 4
%	    fixDuration
%	Column 6
%	    idxTargetColor (balance)
%	Column 5
%	    idxTargetDist (major)
%	Column 7
%	    idxFlankerDist (major[default in test.m])
%	Column 8
%	    idxFlankerColor (balance)
%	Column 16
%	    idxTargetShape  (balance)
%	Column 17
%	    idxDistractorShape  (balance)
tmp=15; % second term is nStims: which is one for crowding since we only have one target
Trials(:, [4 tmp 6 5 7 8 16 17]) = Trialsequence;
Trials(:,4) = Replace(Trials(:,4), 1:numel(conf.fixLevels), conf.fixLevels);
Trials(:, tmp) = NaN(size(Trials,1), 1);

if mode.exclusiveTargetFlankerColor_on
  Trials = Trials(Trials(:,6) ~= Trials(:,8),:);
end

% replace the values since drawObjects() has no access to conf.
Trials(:,16) = Replace(Trials(:, 16), unique(Trials(:,16)), conf.targetShapes);
Trials(:,17) = Replace(Trials(:, 17), unique(Trials(:,17)),conf.distractorShapes);



%	Column 9
%	    crossCoor
Trials(:, 9) = repmat(conf.deg.crossCoor, size(Trials,1),1);


%	    initialize here
Trials(:, 14) = zeros(size(Trials,1), 1);
Trials(:, 15) = zeros(size(Trials,1), 1);



% calculate blockID, to be used for generating/separating several parallel sequences
[whichProcedure codeProcedure]= tunnelSelection(lower(mode.procedureChannel));
switch whichProcedure
    case {'Constant', 'constant'}
        % do SOMETHING, the above generates Constant sequence
        % we need to do blockID to get away from NaN errors introduced in recordCrowdingResponse
    if ~isempty(conf.Constantparams)
        numTen = NaN(numel(conf.Constantparams),1);
        blockID = NaN(size(Trials(:,1),1),1);
        for trialNum = 1:size(Trials(:,1),1)
        for tenNum =1: numel(conf.Constantparams)
            numTen(tenNum,1) = 10^(numel(conf.Constantparams)-tenNum);
        end
        blockID(trialNum,1) = Trials(trialNum,conf.Constantparams) * numTen;
        end
    else
        error('genCrowdingSequence:ConstantRequestedWithoutSayingIt', 'You requested a Constant procedure without specifying which columns of the Trials table to use for it. Are you nuts?')
    end
        Trials(:,2) = blockID;

case {'QUEST' , 'quest'}
    % we use the QUEST procedure here!
    if ~isempty(conf.Constantparams)
        warning('genCrowdingSequence:QUEST', '%d sequences are generated based on combinations of columns %s in Trials, for the QUEST procedure to measure data for the %dth column of Trials', prod(conf.Constantparams), num2str(conf.Constantparams), conf.QUESTparams{1});
        numTen = NaN(numel(conf.Constantparams),1);
        blockID = NaN(size(Trials(:,1),1),1);
        for trialNum = 1:size(Trials(:,1),1)
        for tenNum =1: numel(conf.Constantparams)
            numTen(tenNum,1) = 10^(numel(conf.Constantparams)-tenNum);
        end
        blockID(trialNum,1) = Trials(trialNum,conf.Constantparams) * numTen;
        end
    else
        warning('genCrowdingSequence:QUEST', 'A single sequence is generated for the QUEST procedure to measure data for the %dth column of Trials', conf.QUESTparams{1});
        blockID = ones(size(Trials,1), 1);
    end
%	Column 2
%	    blockID
Trials(:,2) = blockID;
Trials(:, conf.QUESTparams{1}) = codeProcedure;


case {'nUp1Down' , 'nup1down'}
    % we use the nUp1Down (N-up-1-down) procedure here!
    % FIXME: not implemented yet
    % we do not know how many trials should suffice so balancing before
    % the experiment is impossible. Therefore, rather than generating the
    % data here set the probabilities for each parameter here and let the
    % nUp1Down function itself care about random number generation
    error('genCrowdingSequence:nUp1Down', 'Not implemented!');
otherwise
    error('genCrowdingSequence:unknownProcedure', 'procedure %s is unknown!');
end



if mode.once_on > 0
    Trials = Trials(1:mode.once_on, :);
end
end
