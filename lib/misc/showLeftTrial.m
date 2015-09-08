function restcount = showLeftTrial(Trialsequence, theTrial, w, wsize, debug_mode, english_on, kb, skipFile, tactile_on)
  % show the number of remaining trials

  isSkip = 1;
  if ~isSkip
    debug_mode = 1;
    screens=Screen('Screens');
    screenNumber=max(screens);
    kb = keyDefinition();
    english_on = 0;
    if debug_mode
      [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    else
      [w,wsize]=Screen('OpenWindow',screenNumber,0);
    end
  end

  if english_on
    Instruction([num2str(size(Trialsequence, 1) - theTrial + 1), ' remaining '], w, wsize, debug_mode, english_on, kb, getTime('ShowLeftTrial'), skipFile, tactile_on);
  else
    Instruction(['ªπ”– ', num2str(size(Trialsequence, 1) - theTrial + 1), '  ‘¥Œ'], w, wsize, debug_mode, english_on, kb,getTime('ShowLeftTrial'), skipFile, tactile_on);
  end
end

