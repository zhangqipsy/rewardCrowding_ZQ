function [draw] = genCrowdingData(thisTrial, render, conf)
% Generates data.draw for the crowding experiment stimuli
%
% SYNOPSIS: [draw] = genRewardData(thisTrial, render, conf)
%
% INPUT
%
% OUTPUT Add this `draw` field to `data` as data.draw)
%

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 企业�?Version 6.3 (Build 9600)
%
% Author: Hormet, 2015-08-31
% UPDATED: 2015-08-31 16:04:17
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
% (at your option) any later version.  %
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

draw = initializeDraw();
% flankers should not overlap with target
% one radius for the flanker, another for the target
if thisTrial(7) < 2*conf.metric.cir_r
    thisTrial(7) = 2*conf.metric.cir_r;
end
% this is target
if isinf(thisTrial(16))
    % this is circle
    circle.coor =  [render.cx-thisTrial(9)+conf.metric.targetDist(thisTrial(5)) render.cy];
    circle.color =  conf.color.targets{thisTrial(6)};
    circle.r =  conf.metric.cir_r;
    circle.width =  conf.metric.circle_width;
    circle.isFill =  0;
    draw = insertObject(draw, 'circle', circle);

else
    if isfinite(thisTrial(16))
    % poly
    polygon.coor =  [render.cx-thisTrial(9)+conf.metric.targetDist(thisTrial(5)) render.cy];
    polygon.color =  conf.color.targets{thisTrial(6)};
    polygon.points =  octalCoor(2*[0 0 polygon.coor], conf.metric.cir_r, thisTrial(16));
    polygon.width =  conf.metric.circle_width;
    polygon.isFill =  0;
    draw = insertObject(draw, 'poly', polygon);
    end
end % circle or poly


% this is flankers
for iFlanker = 1:conf.nFlankers
    if isinf(thisTrial(17))
        % this is circle
        circle.coor =  [render.cx-thisTrial(9)+conf.metric.targetDist(thisTrial(5)) render.cy+thisTrial(7)*sin(conf.flankerOrientations(iFlanker))];
        circle.color =  conf.color.distractors{thisTrial(8)};
        circle.r =  conf.metric.cir_r;
        circle.width =  conf.metric.circle_width;
        circle.isFill =  0;
        draw = insertObject(draw, 'circle', circle);

    else 
        if isfinite(thisTrial(17))
        % poly
        polygon.coor =  [render.cx-thisTrial(9)+conf.metric.targetDist(thisTrial(5)) render.cy+thisTrial(7)*sin(conf.flankerOrientations(iFlanker))];
        polygon.color =  conf.color.distractors{thisTrial(8)};
        polygon.points =  octalCoor(2*[0 0 polygon.coor], conf.metric.cir_r, thisTrial(17));
        polygon.width =  conf.metric.circle_width;
        polygon.isFill =  0;
        draw = insertObject(draw, 'poly', polygon);
        end
    end % circle or poly
end %for flankers

fix.coor = [render.cx-thisTrial(9) render.cy];
fix.type = '+';
fix.r = conf.metric.fix_r;
fix.width = conf.metric.fix_r2;
fix.color = conf.color.fix;
draw = insertObject(draw, 'fix', fix);

% output data (add to data later since `data` is not in the input augument)
% data.draw = draw;

end
