% ########################
% beginning of th eprogram
% ########################

% Default values for tGuess and tGuessSd
if streq(o.signalKind,'luminance')
  tGuess=-0.5;
  tGuessSd=2;
else
  tGuess=0;
  tGuessSd=4;
end
switch o.thresholdParameter
  case 'spacing',
    nominalCriticalSpacingDeg=0.3*(o.eccentricityDeg+0.45); % Eq. 14 from Song, Levi, and Pelli (2014).
    tGuess=log10(2*nominalCriticalSpacingDeg);
  case 'size',
    nominalAcuityDeg=0.029*(o.eccentricityDeg+2.72); % Eq. 13 from Song, Levi, and Pelli (2014).
    tGuess=log10(2*nominalAcuityDeg);
  case 'contrast',
  otherwise
    error('Unknown o.thresholdParameter "%s".',o.thresholdParameter);
end
if isfinite(o.tGuess)
  tGuess=o.tGuess;
end
if isfinite(o.tGuessSd)
  tGuessSd=o.tGuessSd;
end

o.data=[];
q=QuestCreate(tGuess,tGuessSd,o.pThreshold,o.beta,delta,gamma);
q.normalizePdf=1; % adds a few ms per call to QuestUpdate, but otherwise the pdf will underflow after about 1000 trials.
wrongRight={'wrong','right'};
timeZero=GetSecs;
trialsRight=0;
rWarningCount=0;
runStart=GetSecs;
for trial=1:o.trialsPerRun
  tTest=QuestQuantile(q);
  if o.measureBeta
    offsetToMeasureBeta=Shuffle(offsetToMeasureBeta);
    tTest=tTest+offsetToMeasureBeta(1);
  end
  if ~isfinite(tTest)
    ffprintf(ff,'WARNING: trial %d: tTest %f not finite. Setting to QuestMean.\n',trial,tTest);
    tTest=QuestMean(q);
  end
  if o.saveSnapshot
    tTest=o.tSnapshot;
  end
  switch o.thresholdParameter
    case 'spacing',
      spacingDeg=10^tTest;
      flankerSpacingPix=spacingDeg*o.pixPerDeg;
      flankerSpacingPix=max(flankerSpacingPix,1.2*o.targetHeightPix);
      fprintf('flankerSpacingPix %d\n',flankerSpacingPix);
    case 'size',
      targetSizeDeg=10^tTest;
      o.targetHeightPix=targetSizeDeg*o.pixPerDeg;
      o.targetWidthPix=o.targetHeightPix;
    case 'contrast',
      if streq(o.signalKind,'luminance')
        r=1;
        o.contrast=-10^tTest; % negative contrast, dark letters
        if o.saveSnapshot && isfinite(o.snapshotLetterContrast)
          o.contrast=-o.snapshotLetterContrast;
        end
      else
        r=1+10^tTest;
        o.contrast=0;
      end
  end
  a=(1-LMin/LMean)*o.noiseListSd/o.noiseListBound;
  if o.noiseSD>a
    ffprintf(ff,'WARNING: Reducing o.noiseSD of %s noise to %.2f to avoid overflow.\n',o.noiseType,a);
    o.noiseSD=a;
  end
  if isfinite(o.annularNoiseSD) && o.annularNoiseSD>a
    ffprintf(ff,'WARNING: Reducing o.annularNoiseSD of %s noise to %.2f to avoid overflow.\n',o.noiseType,a);
    o.annularNoiseSD=a;
  end
  switch o.signalKind
    case 'noise',
      a=(1-LMin/LMean)/(o.noiseListBound*o.noiseSD/o.noiseListSd);
      if r>a
        r=a;
        if ~exist('rWarningCount','var') || rWarningCount==0
          ffprintf(ff,'WARNING: Limiting r ratio of %s noises to upper bound %.2f to stay within luminance range.\n',o.noiseType,r);
        end
        rWarningCount=rWarningCount+1;
      end
      tTest=log10(r-1);
    case 'luminance',
      a=(min(cal.old.L)-LMean)/LMean;
      a=a+o.noiseListBound*o.noiseSD/o.noiseListSd;
      assert(a<0,'Need range for signal.');
      if o.contrast<a
        o.contrast=a;
      end
      tTest=log10(-o.contrast);
    case 'entropy',
      a=128/o.backgroundEntropyLevels;
      if r>a
        r=a;
        if ~exist('rWarningCount','var') || rWarningCount==0
          ffprintf(ff,'WARNING: Limiting entropy of %s noise to upper bound %.1f bits.\n',o.noiseType,log2(r*o.backgroundEntropyLevels));
        end
        rWarningCount=rWarningCount+1;
      end
      signalEntropyLevels=round(r*o.backgroundEntropyLevels);
      r=signalEntropyLevels/o.backgroundEntropyLevels; % define r as ratio of number of levels
      tTest=log10(r-1);
    otherwise
      error('Unknown o.signalKind "%s"',o.signalKind);
  end


% ##################
% end of the program
% ##################

end
