function bug()
  % this bug is to test Octave with PTB-3
  % DrawFormattedText seems to be not working well

  [w,render.wsize]=Screen('OpenWindow',0,[0 0 0],[1,1,801,601],[]);
  DrawFormattedText(w, 'Hi', 'center', 'center', 255*[1 1 1]);
  Screen('Flip', w);
  KbWait;
  sca;

end
