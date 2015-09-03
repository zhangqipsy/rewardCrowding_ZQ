function RL_Regards(w, english_on)
  % print out the THANKS screen in different language

  % english_on = 0
  % screens=Screen('Screens');
  % screenNumber=max(screens);
  % [w,wsize]=Screen('OpenWindow',screenNumber,0,[1,1,801,601],[]);

  Screen('TextFont',w, 'Sans');
  if english_on
    DrawFormattedText(w, sprintf(['Experiment finished successfully!\n\n' ...
      'Thanks for your participating.\n\n' ...
      'Press any key to ESCAPE. ']), 'center', 'center', [255, 255, 255]);

  else
    DrawFormattedText(w, sprintf(['ʵ��ɹ����!\n\n' ...
      '��л���Ĳ���!\n\n\n' ...
      '�밴������˳�.']), 'center', 'center', [255, 255, 255]);

  end
  Screen('Flip', w);
  KbStrokeWait;
  sca;
end
