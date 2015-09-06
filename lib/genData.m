function [data] = genRewardData(thisTrial, render, conf, mode)
% Generates data.draw for the reward experiment stimuli
%
% SYNOPSIS: [cond, mode] = genData()
%
% INPUT
%
% OUTPUT [cond
%		mode]
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


draw.circle.coor = octalCoor(render.wsize, conf.metric.range_r, conf.nStims);
draw.circle.color = reshape(cell2mat(conf.color.distractors(thisTrial(:, 16:16+numel(conf.color.distractors)-1))), 3, [])';
draw.circle.r = repmat(conf.metric.cir_r, conf.nStims, 1);
draw.circle.isFill = zeros(conf.nStims, 1);
draw.circle.width = repmat(conf.metric.circle_width, conf.nStims, 1);

draw.bar.coor = draw.circle.coor;
draw.bar.orientation = reshape(cell2mat(conf.distractorOrientations(thisTrial(:, 23:23+numel(conf.color.distractors)-1))), 1, [])';
draw.bar.len = repmat(conf.metric.bar_r, conf.nStims, 1);
draw.bar.width = repmat(conf.metric.bar_r2, conf.nStims, 1);

draw.fix.coor = repmat([render.cx render.cy], conf.nStims, 1);
draw.fix.type = repmat('+', conf.nStims, 1);
draw.fix.r = repmat(conf.metric.fix_r, conf.nStims,1);
draw.fix.width = repmat(conf.metric.fix_r2, conf.nStims,1);


% replace one distractor with target
draw.circle.color(thisTrial(5)) = conf.color.targets{thisTrial(6)};
draw.bar.orientation(thisTrial(5)) = conf.targetOrientations(thisTrial(7));


% output data
data.draw = draw;

end
