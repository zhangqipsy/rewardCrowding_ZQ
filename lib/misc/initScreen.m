function [w, render] = initScreen(render, debug_on)
  % initialize within this function

  Display('Entering initScreen');

  w = Screen('Windows');
  if ~isempty(w)
    % we have the window open already!
    % then exist without creating anything
    w = w(1); % the first one should be non-offscreen window
  else
  Display('initializing Window');
    % open a screen if we do NOT have a screen open already

    AssertOpenGL; % Check if PTB-3 is properly installed on the system
    Screen('Preference', 'VisualDebugLevel', 1); % do NOT show the welcome screen
    if debug_on | IsOctave
      Screen('Preference','SkipSyncTests', 1);
    else
      Screen('Preference','SkipSyncTests', 0);
    end
    if debug_on; Screen('Preference', 'Verbosity', 0);end
    Screen('Preference', 'Verbosity', 0);

    InitializeMatlabOpenGL;

    render.screens=Screen('screens');
    render.screenNumber=max(render.screens);
    screens=Screen('Screens');
    screenNumber=max(screens);
    %[w, rect] = Screen('OpenWindow', screenNumber, 0,[], 32, 2);
    [w, rect] = Screen('OpenWindow', screenNumber, 0*[1 1 1]);
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    if debug_on
      [w,render.wsize]=Screen('OpenWindow',render.screenNumber,render.backgroundColor,[1,1,801,601],[]);
    else
      [w,render.wsize]=Screen('OpenWindow',render.screenNumber,render.backgroundColor,[],32);
    end
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    render = getScreenGeom(w,render);
  end
end
