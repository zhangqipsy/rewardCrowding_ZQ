function [data flow]= recordResponse(flow, data, conf)
% recordResponse records responses
%
% After a response has been collected, decide whether 
% this resource is a correct response. If:
%   response is correct:
%       then record all the data for the first 
%       occurance of the current trialID.
%       then continue doing the next trial with
%       the next trialID
%   reponse is incorrect:
%       move this trial to the end of all trials 
%       for later data collection, labeling with
%       previous trialID
%
%   If a trialID is already present in a trial,
%   it means that trial was a moved trial for 
%   data recollection. In this case, do not change 
%   trialID, and keep using the old trialID.
%
%   During data analysis, all rows of data.Trials 
%   whose counterTillCorrect is larger than 1 could
%   be ignoreѕ, since those are re-collected in a 
%   later trial.
%
%
% SYNOPSIS:[data flow] = recordResponse(flow, data, conf)
%
% INPUT
%
%
%
% OUTPUT data
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
%	Column 16~22
%	    idxDistractorColor
%	Column 23~28
%	    idxDistractorBar
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


%	Column 1
%	    trialN
%	    To be recorded.
data.Trials(flow.nresp, 1) = flow.nresp; % this keeps rising after every trial
%	Column 2
%	    blockID
%	    To be recorded.
data.Trials(flow.nresp, 2) = floor(flow.nresp/conf.restpertrial);
%	Column 3
%	    trialID
%	    To be recorded.
if data.Trials(flow.nresp, 3) == 0 || isnan(data.Trials(flow.nresp, 3))
    flow.isRecollect = 0;
    data.Trials(flow.nresp, 3) = flow.trialID; % represents the trials (condition); the same for re-collected ones
    flow.trialID = flow.trialID + 1;
elseif data.Trials(flow.nresp, 3) > 0 
    % recollecting data, do not change the trialID
    flow.isRecollect = 1;
elseif data.Trials(flow.nresp, 3) < 0 
    % negative trialID -- end of experiment
    flow.isRecollect = 0;
    flow.isquit = 1;
end

%	Column 10
%	    respType
%	    To be recorded.
data.Trials(flow.nresp, 10) = flow.idxResponse;
%	Column 11
%	    respRT
%	    To be recorded.
data.Trials(flow.nresp, 11) = flow.rt;
%	Column 12
%	    respTime
%	    To be recorded.
data.Trials(flow.nresp, 12) = flow.respTime;
%	Column 13
%	    isCorrect
%	    idx:1 key for idx:1 target orientation
%	    To be recorded.
flow.isCorrect = data.Trials(flow.nresp, 7) == flow.idxResponse;
data.Trials(flow.nresp, 13) = flow.isCorrect;

%	Column 14
%	    counterTillCorrect
%	    To be recorded.
%	Column 15
%	    rewardAmount
%	    To be recorded.
data.Trials(flow.nresp, 14) = data.Trials(flow.nresp, 14) + 1;
data.Trials(flow.nresp, 15) = conf.rewardAmounts(1+double(data.Trials(flow.nresp, 9)));


if flow.isCorrect
else
    data.Trials(flow.trialID, 14) = data.Trials(flow.trialID, 14) + 1;
    data.Trials(flow.nresp, 15) = 0;

    % move this trial to the end
    data.Trials = [data.Trials; data.Trials(flow.nresp, :)];
end

flow.nresp    = flow.nresp + 1;  % the total number of response recorded flow.restcount= 0;  % the number of trials from last rest
if flow.nresp > size(data.Trials, 1)
    % all the trials as well as scheduled trials finished collecting correct responses
    % end the experiment
    flow.isquit = 1;
end
end
