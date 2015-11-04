function restcount = restBetweenTrial(restcount, resttime, pertrial, w, wsize, debug_mode, english_on, kb, skipFile, tactile_on)
  % take a rest after some trials

  isSkip = 1;
  if ~isSkip
    eyetracking_mode = 1;
    debug_mode = 1;
    screens=Screen('Screens');
    screenNumber=max(screens);
    english_on = 1;
    restcount = 1;
    pertrial=1;
    kb = keyDefinition();
    resttime=5;
    skipFile=0;
    tactile_on=0;
    if debug_mode
      [w,wsize]=Screen('OpenWindow',screenNumber,0,[ 1,1,801,601],[]);
    else
      [w,wsize]=Screen('OpenWindow',screenNumber,0);
    end
  end

  if restcount == pertrial
      if eyetracking_mode == 1
      %眼动结束
% End of Experiment; close the file first, close graphics window, close data file and shut down tracker
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.5);
    Eyelink('CloseFile');
    
    % download data file
    try
        fprintf('Receiving data file ''%s''\n', edfFile );
        status=Eyelink('ReceiveFile');
        if status > 0
            fprintf('ReceiveFile status %d\n', status);%status 为文件大小，这句将返回文件大小，0表示传输过程被取消，负值表示错误代码
       end
        if 2==exist(edfFile, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
        end
    catch 
        fprintf('Problem receiving data file ''%s''\n', edfFile );
    end    
      end
    if english_on
      %Display(resttime);
      Instruction(['Please rest for ' num2str(resttime) ' seconds.\n\nIf you want to proceed, press any button.'], w, wsize, debug_mode, english_on, kb, resttime, skipFile, tactile_on);
      if eyetracking_mode == 1
      %commandwindow;
mainfilename = [data.Subinfo{1} , render.dataSuffix, tunnelSelection(mode.procedureChannel), datestr(now, 'yyyymmddTHHMMSS')];
dummymode=0;
showboxes=1;
el=EyelinkInitDefaults(wnd);
if ~EyelinkInit(dummymode, 1)
    fprintf('Eyelink Init aborted.\n');
    cd(CurrDir);
    abort(CurrDir);
end
Eyelink('Command', 'set_idle_mode');
Eyelink('Command', 'clear_screen 0')
 Eyelink('command','draw_box %d %d %d %d %d',rect(3)/2-17, rect(4)/2-17, rect(3)/2+17, rect(4)/2+17,15);
 Eyelink('command','draw_cross %d %d %d',rect(3)/2,rect(4)/2,8);
[v vs]=Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );
% make sure that we get event data from the Eyelink
% Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
Eyelink('command', 'link_event_data = GAZE,GAZERES,HREF,AREA,VELOCITY');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,BLINK,SACCADE,BUTTON');
 
% open file to record data to
edfFile=[mainfilename '.edf'];
Eyelink('Openfile', edfFile);       
% STEP 4
% Calibrate the eye tracker
EyelinkDoTrackerSetup(el);
 
% STEP 6
% do a final check of calibration using driftcorrection
success=EyelinkDoDriftCorrection(el);
if success~=1
    cd(CurrDir);
    abort(CurrDir);
end
Screen('Flip',  wnd, [], 1); % don't erase buffer
eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
if eye_used == el.BINOCULAR; % if both eyes are tracked
    eye_used = el.LEFT_EYE; % use left eye
end
%开始记录
Eyelink('startrecording');     
      end
    else
      Instruction(['请休息 ' num2str(resttime) ' 秒。\n\n如果希望继续，请按任意键继续。'], w, wsize, debug_mode, english_on, kb, resttime, skipFile, tactile_on);
    end
    restcount = 1;
  else
    restcount = restcount + 1;
  end
  
end
