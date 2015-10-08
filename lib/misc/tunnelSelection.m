function [sProcedure, code]= tunnelSelection(ch)
% Return the procedure string and the channel code for the channel specified in the `ch` input
%
% SYNOPSIS:hProcedure = channelSelection(ch)
%
% INPUT
%
%
%
% OUTPUT 
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
code = NaN;
sProcedure = NaN;

channelTable = {...
                'Constant',  0;...
                'QUEST',    -1;...
                'nUp1Down', -2;...
                };

% NOTE: isequal in GNU Octave can handle numerics as well as strings
%       not sure about MATLAB though
%       Also note that GNU Octave lower(n) returns n when n is numeric
theRow = logical(sum(cellfun(@(x) isequal(lower(x), lower(ch)), channelTable, 'UniformOutput', true), 2));

if ismember(find(theRow), 1:size(channelTable, 1))
    sProcedure = channelTable{theRow, 1};
    code = channelTable{theRow, 2};
else
    error('channelSelection:undefinedRequest', 'The requested channel: %s was not found in the `channelTable`!', ch);
end
    

end
