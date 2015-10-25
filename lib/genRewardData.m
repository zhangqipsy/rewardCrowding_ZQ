function [draw, render] = genRewardData(thisTrial, render, conf)
% Generates data.draw for the reward experiment stimuli
%
% SYNOPSIS: [draw] = genRewardData(thisTrial, render, conf)
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

% we calculate cm/pix automatically!
% Any user input before is overridden
scale             =  1;          % linear magnifier
%eccentricityPix=round(pixPerCm*o.distanceCm*tand(o.eccentricityDeg));
% use pixPerCm from getScreenGeom()
if ~isfield(render, 'pixPerCm')
    warning('genRewardData:pixPerCm', 'pixPerCm not found from render! Re-initializing screen...')
% this gets loaded from the main function rewardedLearning when we open screen using getScreenGeom()
% However, when doing debug test using test draw, then it fails because screen does not open until
% we draw the real object, but we ONLY draw after we have generated the data to draw
[w, render] = initScreen(render, 0); %debug_on=0 so we are always using full screen geometry
end
metric = structfun(@(x) scale*round(tand(x)*conf.viewDist*render.pixPerCm), conf.deg, 'UniformOutput', false);
metric.scale = scale;
conf.metric = metric;

draw.circle.coor = octalCoor(render.wsize, conf.metric.range_r, conf.nStims);
draw.circle.color = reshape(cell2mat(conf.color.distractors(thisTrial(:, 16:16+conf.nStims-1))), 3, [])';
draw.circle.r = repmat(conf.metric.cir_r, conf.nStims, 1);
draw.circle.width = repmat(conf.metric.circle_width, conf.nStims, 1);
draw.circle.isFill = zeros(conf.nStims, 1);

draw.line.coor = draw.circle.coor;
draw.line.orientation = conf.distractorOrientations(thisTrial(:, 22:22+conf.nStims-1));

draw.line.len = repmat(conf.metric.bar_r, conf.nStims, 1);
draw.line.width = repmat(conf.metric.bar_r2, conf.nStims, 1);
draw.line.color = repmat(conf.color.bar, conf.nStims, 1);

% NOTE: look at coor here: location is determined using cx
draw.fix.coor = [render.cx render.cy];
draw.fix.type = '+';
draw.fix.r = conf.metric.fix_r;
draw.fix.width = conf.metric.fix_r2;
draw.fix.color = conf.color.fix;


% replace one distractor with target
draw.circle.color(thisTrial(5),:) = conf.color.targets{thisTrial(6)};
draw.line.orientation(thisTrial(5)) = conf.targetOrientations(thisTrial(7));


% output data (add to data later since `data` is not in the input augument)
% data.draw = draw;

end
