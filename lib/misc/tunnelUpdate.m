function [thisTrial, Q]= tunnelUpdate(ch, conf, thisTrial, Q, blockID)
[whichProcedure, codeProcedure]= tunnelSelection(lower(ch));

% lastTrial is the last trial in the same quest sequence
if  ~exist('Q', 'var') == 1 || isempty(Q)

  % initialize Q switch whichProcedure


  switch whichProcedure
    case {'Constant', 'constant'}
      % do nothing
      %Display('Non-adaptive design procedure. Not generating Q!');
      Q = {};

    case {'QUEST' , 'quest'}
      % we use the QUEST procedure here!
      % update the database and get new value
      tGuess=conf.QUESTparams{3};
      tGuessSd=conf.QUESTparams{4};
      pThreshold=conf.QUESTparams{5};
      beta=conf.QUESTparams{6};
      delta=conf.QUESTparams{7};
      gamma=conf.QUESTparams{8};
      q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);
      q.normalizePdf=1; % This adds a few ms per call to QuestUpdate, but otherwise the pdf will underflow after about 1000 trials.

      % blockID type, Quest Q, tTestLast, measureLast
      Q = {unique(blockID) repmat(q, numel(unique(blockID)),1) NaN(numel(unique(blockID)),1) NaN(numel(unique(blockID)),1)};

      % get the first tTest
      whichBlockID = Q{1} == thisTrial(2);
      tTest=QuestQuantile(Q{2}(whichBlockID));	% Recommended by Pelli (1987), and still our favorite.

      Q{3}(whichBlockID) = tTest;
      thisTrial(conf.QUESTparams{1}) = 10^tTest;


    case {'nUp1Down' , 'nup1down'}
      % we use the nUp1Down (N-up-1-down) procedure here!
      % update the database and get new value
      % FIXME: not implemented yet
      %q = initializeQ();
      error('tunnelUpdate:nUp1Down', 'Not implemented!');

    otherwise
      error('genCrowdingSequence:unknownProcedure', 'procedure %s is unknown!', whichProcedure);
  end

  return



else
  % non-initializing part

  switch whichProcedure
    case {'Constant', 'constant'}
      % do nothing

    case {'QUEST' , 'quest'}
      % we use the QUEST procedure here!
      % update the database and get new value
      whichBlockID = Q{1} == thisTrial(2);
      if isnan(Q{3}(whichBlockID))
          % first trial
          % we already created using the switch above
          % do nothing

      else
        % this is not the first trial in this blockID type
        % therefore update with the latest trial result
        Q{2}(whichBlockID) = QuestUpdate(Q{2}(whichBlockID),Q{3}(whichBlockID), Q{4}(whichBlockID)); % Add the new datum (actual test intensity and observer response) to the database.

      end

        tTest=QuestQuantile(Q{2}(whichBlockID));	% Recommended by Pelli (1987), and still our favorite.
        Q{3}(whichBlockID) = tTest; % save in Q database to update next Quest call
        thisTrial(conf.QUESTparams{1}) = 10^tTest;

    case {'nUp1Down' , 'nup1down'}
      % we use the nUp1Down (N-up-1-down) procedure here!
      % update the database and get new value
      % FIXME: not implemented yet

    otherwise
      error('genCrowdingSequence:unknownProcedure', 'procedure %s is unknown!', whichProcedure);
  end %switch for existing Q


end % if Q exists

end % function
