%drawObjects draws objects in a draw struct object.
%
% SYNOPSIS: data = drawObjects(w, render, draw)
%
% INPUT
%   w is the window pointer to draw
%   render.wsize is the window size
%   draw.circle, draw.bar, draw.fix are the main three objects
%   Each are by themselves structures whose fields are matrix, 
%   such as draw.circle.coor, draw.circle.color; each row is 
%   another object. For example, to draw six circles, you need
%   draw.circle.coor to be 6x2 matrix, the two columns for the 
%   x and y coordinates.
%
%
% OUTPUT data
%

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 企业版 Version 6.3 (Build 9600)
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

% do some sanity checks

% draw circles
if exist('draw', 'variable') == 1 && isfield(draw, 'circle')
    if ~isempty(draw.circle.coor)

% draw seperately?
if all(draw.circle.isFill == draw.circle.isFill(1))
    % all of the same type; draw together
    if draw.circle.isFill(1) == 1
        drawCmd = 'FillOval';
    else
        drawCmd = 'FrameOval';
    end
        drawCircle(w, draw.circle, drawCmd);

else
    % seperately draw
    warning('drawObjects:circlsIsFill', 'Filled and Framed circles are found!');
    for іCircle = 1:size(draw.circle.coor, 1)
        if draw.circle.isFill(iCircle ) == 1
            drawCmd = 'FillOval';
        else
            drawCmd = 'FrameOval';
        end
        drawCircle(w, render, draw.circle(iCircle, :));
    end
end
end



% draw lines
if exist('draw', 'variable') == 1 && isfield(draw, 'line')
    if ~isempty(draw.circle.coor)
        drawLine(w, render, draw.line);
    end
end


% draw fixation
if exist('draw', 'variable') == 1 && isfield(draw, 'line')
    if ~isempty(draw.circle.coor)
       if strcmp(draw.fix.type, '+')
           % transorm into line object
           draw.fix.coor = repmat(draw.fix.coor, 2, 1);
           draw.fix.orientation = [0 90]';
           draw.fix.len = repmat(draw.fix.r, 2, 1);
           draw.fix.width = repmat(draw.fix.width, 2, 1);
           draw.fix.color = repmat(draw.fix.color, 2, 1);

           % draw as a line object
           drawLine(w, render, draw.line);
       else
           % call the fixation function
           % this function has no support for width, coor yet
           fixation(w, draw.fix.type, draw.fix.color, render.backgroundColor);
    end
end

end



% helper functions
function drawCircle(w, circle, cmd)
OvalRect = CenterRectOnPoint([zeros(size(circle.r,1), 2) circle.r], circle.coor(:,1), circle.coor(:,2));
Screen(cmd, w, circle.color', OvalRect', circle.width');
end




function drawLine(w, render, line, cmd)

    % transform lines
    XY = [];
    for iLine=1:size(line.coor,1)
        xy = [0 line.len(iLine); 0 line.len(iLine)];
        theta = line.orientation(iLine);
        shiftX = line.coor(iLine, 1);
        shiftY = line.coor(iLine, 2);
        rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];
        shift = [[eye(2); zeros(1,2)] [shiftX; shiftY; 1] ];
        % now first rotate, then shift
        xy = shift * [[xy*rot]'; ones(1, size(xy, 1))];
        xy(3,:) = [];
        XY(:, iLine) = xy;
    end

    % each line has two columns, first is the starting point of the lineColors
    % the second is the ending point of the line 
    % For each of the two points, we need to specify the color 
    lineColors = reshape(repmat(line.color, 1, 2)', 3, []);
    Screen('DrawLines', w, XY, line.width', lineColors,[], 2);
end
