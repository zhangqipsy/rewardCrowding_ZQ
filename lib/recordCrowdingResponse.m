function [data flow]= recordCrowdingResponse(flow, data, conf)
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
%   be ignore�? since those are re-collected in a
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
%

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 浼佷笟鐗?Version 6.3 (Build 9600)
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


% FIXME: this code is still from the rewardedLearning ones
% update it
% ###################################################################

%	Column 1
%	    trialN
%	    To be recorded.
data.Trials(flow.nresp, 1) = flow.nresp; % this keeps rising after every trial
%	Column 2
%	    blockID
%	    this controls the adaptive sequence!
%	Column 3
%	    trialID
%	    Trial number in this adaptive sequence
data.Trials(flow.nresp,3) = sum(data.Trials(:,2)==data.Trials(flow.nresp,2) & ~isnan(data.Trials(:,10)));

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
flow.isCorrect = Replace(data.Trials(flow.nresp, 16), conf.targetShapes, 1:numel(conf.targetShapes)) == flow.idxResponse;
data.Trials(flow.nresp, 13) = flow.isCorrect;

%	Column 14
%	    counterTillCorrect
%	    not used for 2AFC
%	Column 15
%	    rewardAmount
%	    not used for 2AFC

disp(flow.Q)
if isempty(flow.Q); isAdaptive = 0;else isAdaptive = 1;end
if isAdaptive
flow.Q{4}(flow.Q{1}==data.Trials(flow.nresp,2)) = flow.isCorrect;
end

flow.nresp    = flow.nresp + 1;  % the total number of response recorded flow.restcount= 0;  % the number of trials from last rest
Display([flow.nresp size(data.Trials, 1)])

if flow.nresp > size(data.Trials, 1) || data.Trials(flow.nresp, 3) < 0
    % all the trials as well as scheduled trials finished collecting correct responses

if isAdaptive
    data.t = zeros(numel(flow.Q{1}), 3);
    for iQ = 1:numel(flow.Q{1}) % each of the Quest procedure
        % compute
        % Recommended by Pelli (1989) and King-Smith et al. (1994). Still our favorite.
        data.t(iQ,:)=[flow.Q{1}(iQ) QuestMean(flow.Q{2}(iQ)) QuestSd(flow.Q{2}(iQ))]; % blockID, t, tSD
    end
end
        % end the experiment
        flow.isquit = 1;
end

