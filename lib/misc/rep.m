function u = rep(v, n)
%REP repeats elements of vector variable times
%
% SYNOPSIS: u = rep(v, n)
%
% INPUT v the original vector to be repeated, should be 1xn or nx1 size
%		n the number of times the elements are to be repeated, should be of the same size as v. If scalar, this simply returns the result of repmat.  
%
% OUTPUT u
%

% created with MATLAB ver.: 8.0.0.783 (R2012b)
% on Microsoft Windows 7 Version 6.1 (Build 7601: Service Pack 1)
%
% Author: Hormetjan Yiltiz, 2015-04-08
% UPDATED: 2015-04-08 19:14:41
%
% HISTORY
% yyyy-dd-mm	whoami	log
% 2015-04-08	Hormetjan Yiltiz	Created it.
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

switch nargin
  case 0
    error('No input arguments!');
  case 1
    warning('No replications were generated!');
  case 2
    if isscalar(n)
      warning('Consider using RESHAPE for higher performance.');
      n = n + zeros(size(v));
    end
end


% according to a pretty good benchmarking, we are using the cumsum+diff
% method here. Link for benchmark:
% https://stackoverflow.com/questions/1975772/repeat-copies-of-array-elements-run-length-decoding-in-matlab/29084077#29084077
clens = cumsum(n);
idx(clens(end))=0;
idx([1 clens(1:end-1)+1]) = diff([0 v]);
u = cumsum(idx);

% % Here are several other ways to do it, all of which are benchmarked in the
% % link mentioned above.
% % repmat with arrayfun
% u = arrayfun(@(x) repmat(v(x), n(x), 1), 1:numel(v), 'uni', 0);
% u = vertcat(u{:});
% % cell2mat(arrayfun(@(x) repmat(v(x), [1 n(x)]), 1:numel(n), 'uniformoutput',0))
% 
% % pure cumsum
% B(cumsum(n) + 1) = 1;
% idx = cumsum(B) + 1;
% idx(end) = [];
% u = v(idx);
% 
% 
% % gnovice's solution to run-length-decoding
% % (http://stackoverflow.com/a/1975835/2778484)
% % rld_cumsum.m
% index = zeros(1,sum(b));
% index([1 cumsum(b(1:end-1))+1]) = 1;
% c = a(cumsum(index));
% 
% % cumsum with diff
% % Divakar's solution to run-length-decoding
% % (http://stackoverflow.com/a/29079288/2778484)
% % rld_cumsum_diff.m
% clens = cumsum(n);
% idx(clens(end))=0;
% idx([1 clens(1:end-1)+1]) = diff([0 v]);
% u = cumsum(idx);
% 
% 
% % cumsum & accumarray
% % knedlsepp5cumsumaccumarray.m
% % knedlsepp's solution to run-length-decoding originally from http://stackoverflow.com/a/28615814/2778484
% % (results in http://stackoverflow.com/a/29079288/2778484)
%  
% %// Actual computation using column vectors
% V = cumsum(accumarray(cumsum([1; runLengths(:)]), 1));
% V = V(1:end-1);
% V = reshape(values(V),[],1);
% 
% 
% % pure bsxfun
% A1 = v(ones(1,max(n)),:);
% u = A1(bsxfun(@le,[1:max(n)]',n));
% 
% % pure indexing with for
% % naive_jit_test.m
% u(sum(n))=0;
% counter = 1;
% for idx = 1 : numel(n)
%     u(counter : counter + n(idx) - 1) = v(idx);
%     counter = counter + n(idx);
% end


end