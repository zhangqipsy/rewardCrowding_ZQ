function h = clearPlot(h, G, typeSeed)
%CLEARPLOT is a nice wrapper for built-in PLOT function that automatically rotates along linestyles and colors.
%
% SYNOPSIS: h = clearPlot(h, G, typeSeed)
%
% INPUT h
%			An axis object form PLOT which has several lines.
%		G
%			Data groups. This variable could be one of several types below:
%			1) a numeic array with length of the number of factors (group)
%			 for the lines. The value of the factors are used for the
%			 rotation rules. The first factor rotates quickest.
%			2) a 1xn, 2xn or 3xn matrix where n is the number of lines in
%			the plot axis h. Each row is used as an index for the pool.
%			Rows are used in the order of color, linestyle and marker type.
%           3) a scalar number indicating the type of line property to be
%           used. 1: colors, 2: line style, 3: marker type.
%		typeSeed
%			A 1x3 cell array with chars that will be used as the pool for line color, line type, and marker
%
% OUTPUT h
%

% created with MATLAB ver.: 8.0.0.783 (R2012b)
% on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% Author: Hormetjan Yiltiz, 2015-04-28
% UPDATED: 2015-04-28 20:05:14
%
% HISTORY
% yyyy-dd-mm	whoami	log
% 2015-04-28	Hormetjan Yiltiz	Created it.
%
%
% Copyright 2015 by Hormetjan Yiltiz <hyiltiz@gmail.com>
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

% Define local pool
pool.local.color = {... % first cell element is for color
  'black';...
  'red';...
  'blue';...
  'green';...
  'cyan';...
  'magenta';...
  'yellow';...
  'white';...
  };
pool.local.color(9) = {'black'};

pool.local.linestyle = {...
  '-' ;... %     solid (default if not specified)
  '--';... %    dashed
  ':' ;... %     dotted
  '-.';... %    dashdot
  ''  ;... %(none)  no line
  };
pool.local.linestyle(9) = {''};

pool.local.marker = {...
  'o';... %     circle
  '+';... %     plus
  'x';... %     x-mark
  '*';... %     star
  's';... %     square
  'd';... %     diamond
  '.';... %     point
  '' ;... %     none (default if not specified)
  };
pool.local.marker(9) = {''};

pool.local.marker; 
pool = pool.local;

switch nargin
  case 3
    if ischar(typeSeed) && strcmpi(typeSeed, 'default')
      % use default pool order
      pool.default.color = num2cell(get(0,'DefaultAxesColorOrder'),2);
      pool.default.linestyle = cellstr(get(0,'DefaultAxesLineStyleOrder'));
      pool = pool.default; % override everything in pool with default values
    else
      % use user defined pool order
      pool.userDefined.color = squeeze(typeSeed{1}); % first cell element is for color
      pool.userDefined.linestyle = squeeze(typeSeed{2});
      pool.userDefined.marker = squeeze(typeSeed{3});
      pool = pool.userDefined;
    end
    
  case 2
    if numel(size(G)) == 2 && all(size(G) > 1) && size(G, 2) == numel(h)
      % specified in matrix form (design matrix)
      switch size(G, 1)
        case 1
          % NEVER the case; use single scalar or an factor array instead.
          % If you need to specify exact color indices (some lines might
          % share the same), then please speficy in matrix form with 2 or 3
          % rows.
          % only colors are specified
          Gm = [G; ones(1, size(G, 2)); 9*ones(1, size(G, 2))];
        case 2
          % colors and linestyle are specified
          Gm = [G; 9*ones(1, size(G, 2))];
        case 3
          % colors, linestyle and markers are specified
          Gm = G;
        otherwise
          error('Too many properties (rows) specified for line groups!');
      end
      
    elseif numel(size(G)) == 2 && numel(G) > 1 && any(size(G) == 1) && prod(G) == numel(h)
      % specified in array form (factor list)
      % convert to design matrix
      Gm = ones(1,3);
      Gm(1:numel(G)) = G;
      Gm = fullfact(Gm)';
      
    elseif numel(G) == 1
      % specified as the type of line property.
      % Generate default design matrix for that row, keeping others as 1s
      Gm = ones(3, numel(h));
      Gm(G,:) = 1:numel(h);
      
    else
      error('Line group is poorly specified!');
    end
  case 1
    warning('Choosing colors as the target properties by default.');
    G = 1;
    Gm = ones(3, numel(h));
    Gm(G,:) = 1:numel(h);
  otherwise
    error('At least provide the axis handle h and line groups G!');
end

lineProperties.color = pool.color(Gm(1,:));
lineProperties.linestyle = pool.linestyle(Gm(2,:));
lineProperties.marker = pool.marker(Gm(3,:));

% if more than one color is specified, do not begin form Black
if numel(unique(lineProperties.color)) > 1
    lineProperties.color = pool.color(Gm(1,:)+1);
end 

if numel(unique(lineProperties.marker)) > 1
set(h, {'Color'}, lineProperties.color,...
  {'LineStyle'}, lineProperties.linestyle,...
  {'Marker'}, lineProperties.marker);
else
set(h, {'Color'}, lineProperties.color,...
  {'LineStyle'}, lineProperties.linestyle);
end

end