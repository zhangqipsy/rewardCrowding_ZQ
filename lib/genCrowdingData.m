function [draw] = genCrowdingData(thisTrial, render, conf, mode)
% Generates data.draw for the crowding experiment stimuli
%
% SYNOPSIS: [draw] = genRewardData(thisTrial, render, conf, mode)
%
% INPUT
%
% OUTPUT Add this `draw` field to `data` as data.draw)
%

% created with MATLAB ver.: 8.5.0.197613 (R2015a)
% on Microsoft Windows 8.1 企业版 Version 6.3 (Build 9600)
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

draw = initializeDraw();
% this is target
if isinf(thisTrial(16))
    % this is circle
    draw.circle.coor = [draw.circle.coor; [thisTrial(9)+conf.metric.targetDist(thisTrial(5)) render.cy]];
    draw.circle.color = [draw.circle.color; conf.color.targets{thisTrial(6)}];
    draw.circle.r = [draw.circle.r; conf.metric.cir_r];
    draw.circle.width = [draw.circle.width; conf.metric.circle_width];
    draw.circle.isFill = [draw.circle.isFill; 0];

elseif isnumeric(thisTrial(16))
    % poly
    draw.poly.coor = [draw.poly.coor; [thisTrial(9)+conf.metric.targetDist(thisTrial(5)) render.cy]];
    draw.poly.color = [draw.poly.color; conf.color.targets{thisTrial(6)}];
    draw.poly.points = [draw.poly.points; octalCoor(render.wsize, conf.metric.cir_r, thisTrial(16))];
    draw.poly.width = [draw.poly.width; conf.metric.circle_width];
    draw.poly.isFill = [draw.poly.isFill; 0];
end % circle or poly

% this is flankers
for iFlanker = 1:conf.nFlankers
    if isinf(thisTrial(17))
        % this is circle
        draw.circle.coor = [draw.circle.coor; [thisTrial(9)+conf.metric.targetDist(thisTrial(5)) render.cy+sin(conf.flankerOrientations(iFlanker))]];
        draw.circle.color = [draw.circle.color; conf.color.distractors{thisTrial(8)}];
        draw.circle.r = [draw.circle.r; conf.metric.cir_r];
        draw.circle.width = [draw.circle.width; conf.metric.circle_width];
        draw.circle.isFill = [draw.circle.isFill; 0];

    elseif isnumeric(thisTrial(16))
        % poly
        draw.poly.coor = [draw.poly.coor; [thisTrial(9)+conf.metric.targetDist(thisTrial(5)) render.cy+sin(conf.flankerOrientations(iFlanker))]];
        draw.poly.color = [draw.poly.color; conf.color.distractors{thisTrial(8)}];
        draw.poly.points = [draw.poly.points; octalCoor(render.wsize, conf.metric.cir_r, thisTrial(17))];
        draw.poly.width = [draw.poly.width; conf.metric.circle_width];
        draw.poly.isFill = [draw.poly.isFill; 0];
    end % circle or poly
end %for flankers

draw.fix.coor = [render.cx-thisTrial(9) render.cy];
draw.fix.type = '+';
draw.fix.r = conf.metric.fix_r;
draw.fix.width = conf.metric.fix_r2;
draw.fix.color = conf.color.fix;

% output data (add to data later since `data` is not in the input augument)
% data.draw = draw;

end
