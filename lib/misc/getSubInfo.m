function Subinfo= getSubInfo(isSkip)

    if nargin == 0
        isSkip = false;
    end

  promptParameters = {'Subject ID','His','Date','Subject Name', 'Age', 'Gender (F or M?)','Handedness (L or R)', 'Left eyesight/degree', 'Right eyesight/degree', 'Phone'};

  defaultParameters = {'01','','2015/10/1','zhangqi', '20','F', 'R', '1.0/250', '1.0/250', '13244445555'};

  if isSkip
      Subinfo = defaultParameters;
  else

  if ~ IsOctave

      % this is for MATLAB with gui
    Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
    if isempty(Subinfo)
      error('Subject information not entered!');
    end;


  else
    % This is for octave
    % actually this could be said as CLI since octave now has inputdlg() support! Yay!
    %Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);
    Subinfo = cell(length(defaultParameters),1);
    for i = 1 : length(promptParameters)
      getinput = input(['Please enter ', promptParameters{i}, ':'],'s');
      if isempty(getinput)
        getinput = defaultParameters{i};
      end
      Subinfo{i,1} = getinput;
    end

    if isempty(Subinfo)
      error('Subject information not entered!');
    end;
end % isOctave
end % isSkip
end %function
