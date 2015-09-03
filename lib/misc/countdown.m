function countdown(wptr, countSecs, step, xcenter, ycenter)
stops = countSecs:-step:1;
oldTextSize=Screen('TextSize', wptr, 48);
save buggy
for iStop = stops
   DrawFormattedText_box(wptr, num2str(iStop), xcenter-25, ycenter-40, 255);
   Screen('Flip', wptr);
   WaitSecs(step); % dont use getTime!
end

Screen('TextSize', wptr, oldTextSize);
end