function newfunc(fxnexpr, whichlicense)
%CODETEMPLATE creates a new m-file with proper help layout, and licensing.
%
% SYNOPSIS: newfunc(fxnname)
%
% INPUT fxnname: name of the new function. CodeTemplate will check that the
%                function name has not been used yet, and it will ask for
%                additional input, such as H1-line via inputdlg
%
% OUTPUT None. The function creates a new m-file and opens it in the editor
%
% REMARKS
%
% created with MATLAB ver.: 7.10.0.499 (R2010a) on Microsoft Windows 7 Version 6.1 (Build 7600)
%
% created by: Jonas Dorn
% DATE: 31-Mar-2010
% Added auto-licensing and example generation support with emails
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%==============
%% DEFAULTS
%==============

% add common superclass for value and handle classes, respectively
%superclass = {'myClass','myHandle'};
superclass = {[],'handle'};


%===============
%% CHECK INPUT
%===============

% if no input argument, assign empty to functionname
if nargin < 1 || isempty(fxnexpr) || ~ischar(fxnexpr)
  fxnexpr = [];
end

if nargin < 2
  whichlicense = [];
end

% parse the first argument to newfunc
A = strtrim(regexp(fxnexpr,'^(.*)=', 'tokens'));
if ~isempty(A)
fxnout = cell2mat(A{:});
end
A = strtrim(regexp(fxnexpr,'\((.*)\)', 'tokens'));
fxnin = cell2mat(A{:});
fxnname = strtrim(regexprep(fxnexpr,'(.*=)|(\(.*\))', ''));

% check whether function already exists - only if given as input
if ~isempty(fxnname)
  fxnCheck = which(fxnname);
  if ~isempty(fxnCheck)
    warning('%s already exists: %s\n Creating a shadow, or consider other names.',fxnname,fxnCheck);
  end
end

if isempty(fxnout)
  fxnout = 'argout';
end
if isempty(fxnin)
  fxnin = 'argin';
end

%==============


%================
%% GATHER DATA
%================

% data-gathering stage begins below
% getenv() and version are used to derive environmental variables

% find username. This will return empty on Linux, but we have a line for
% the username in the input dialogue, anyway.
username = getenv('username');
email = 'hyiltiz@gmail.com';


try %#ok<TRYNC>
  % try to resolve user name - I use a function I called username2name to
  % change e.g.  'jdorn' into 'Jonas Dorn'
  username = username2name(username);
end

% get version, OS, date
vers    = version;
datetoday = datestr(now, 'yyyy-mm-dd');
datenow = datestr(now,'yyyy-mm-dd HH:MM:SS');

% getenv('OS') does not work on Mac. Query the OS like ver.m
% find platform OS
if ispc
  platform = [system_dependent('getos'),' ',system_dependent('getwinsys')];
elseif ismac
  [fail, input] = unix('sw_vers');
  if ~fail
    platform = strrep(input, 'ProductName:', '');
    platform = strrep(platform, sprintf('\t'), '');
    platform = strrep(platform, sprintf('\n'), ' ');
    platform = strrep(platform, 'ProductVersion:', ' Version: ');
    platform = strrep(platform, 'BuildVersion:', 'Build: ');
  else
    platform = system_dependent('getos');
  end
else
  platform = system_dependent('getos');
end
os = platform;

% ask for the rest of the input with inputdlg

% set up inputdlg
inPrompt = {'Username:',...
  'Email:', ...
  'FuncName:',...
  'Description: ''FUNCTIONNAME does ...'' (captitalized function name)',...
  'Synopsis: ''[output1, output2] = functionname(input1, input2)',...
  'ArgIn: Input arguments description (use \n for additional line breaks)',...
  'ArgOut: Output arguments description (use \n for additional line breaks)',...
  'Examples: (use \n for additional line breaks)',...
  'Type: Function: 1; Value Class: 2; Handle Class: 3; Subclass: superclass-name'};

inTitle = 'Please describe your function';
numLines = repmat([1,100],numel(inPrompt),1);
parsePrompt = regexp(inPrompt,'^\<(\w+):\>','tokens');
parsePrompt = [parsePrompt{:}];
parsePrompt = [parsePrompt{:}];
parsePrompt = cell2struct(num2cell(1:numel(parsePrompt)), parsePrompt, 2);
numLines([parsePrompt.ArgIn parsePrompt.ArgOut parsePrompt.Examples],1) = 3;
% assign defaultAnswer
[defaultAnswer{1:numel(inPrompt)}] = deal('');
% assign username in default answers
defaultAnswer{parsePrompt.Username} = username;
defaultAnswer{parsePrompt.Email} = email;
defaultAnswer{parsePrompt.Type} = '1';

% if we have a function name already, all will be simpler
if ~isempty(fxnname)
  defaultAnswer{parsePrompt.FuncName} = fxnname;
  defaultAnswer{parsePrompt.Description} = sprintf('%s ...', upper(fxnname));
  defaultAnswer{parsePrompt.Synopsis} = sprintf('%s = %s(%s)', fxnout, fxnname, fxnin);
  defaultAnswer{parsePrompt.ArgIn} = sprintf('%s', regexprep(fxnin,' *, *', '\n'));
  defaultAnswer{parsePrompt.ArgOut} = sprintf('%s', regexprep(fxnout,' *, *', '\n'));
  defaultAnswer{parsePrompt.Examples} = sprintf('%s = %s(%s)', fxnout, fxnname, fxnin);
end

% loop till description is ok
ok = false;

while ~ok

  % get input
  description = inputdlg(inPrompt, inTitle, numLines, defaultAnswer);

  % check for user abort
  if isempty(description)
    error('description cancelled by user');
  else
    ok = true; % hope for the best
  end

  % read description. Functionname, description and synopsis are required
  fxnname = description{parsePrompt.FuncName};
  if isempty(fxnname) || isempty(description{parsePrompt.Username})...
      || isempty(description{parsePrompt.Description}) || isempty(description{parsePrompt.Synopsis}) ||...
      any(findstr(description{parsePrompt.Description},'...')) || isempty(regexpi(description{parsePrompt.Synopsis},fxnname))
    h = errordlg('Username, function name, description and synopsis are required inputs!');
    uiwait(h);
    ok = false;
  end

  % check whether function already exists (again)
  fxnCheck = which(fxnname);
  if ~isempty(fxnCheck)
    h = errordlg('%s already exists: %s',fxnname,fxnCheck);
    uiwait(h);
    ok = false;
  end

  % check for ok and update defaultAnswer with description if necessary
  if ~ok
    defaultAnswer = description;
  end

end % while

% read other input
username = description{parsePrompt.Username};
desc = description{parsePrompt.Description};
synopsis = description{parsePrompt.Synopsis};
% if there are line breaks in inputtext and outputtext: make sure that
% these lines will still be commented!
inputtext = parseInvisible(description{parsePrompt.ArgIn});
outputtext = parseInvisible(description{parsePrompt.ArgOut});
exampletext = parseInvisible(description{parsePrompt.Examples});


% license selection
licenseList = {'GPLv3+', 'BSD 3-Clause', 'MIT', 'Proprietary'};
if isempty(whichlicense)
[nlic, ok] = listdlg('PromptString','Select a license:',...
  'Name', 'Licenses',...
  'SelectionMode','single',...
  'ListSize', [160 100],...
  'InitialValue', 1,...
  'OKString', 'OK',...
  'CancelString', 'Unsure',...
  'ListString',licenseList);

if ~ok
  % I am unsure what all that licenses are about. Need guidance.
  % TODO: simple guidance for choosing the right license for the work.
  warning('Using GNU General Public Licence version 3 or later (GNU GPLv3+) by default.');
  whichlicense = 'GPLv3+';
else
  % just select the license
  whichlicense = licenseList{nlic};
end
end
selectedLicense = selectLicense(whichlicense);


% ask for directory to save the function
dirName = uigetdir(pwd,'select save directory');
if dirName == 0
  error('directory selection cancelled by user')
end
% end of data-gathering stage

%=================

%=================
%% WRITE FUNCTION
%=================

% create the filename based on the function name
fsuffix = '.m';
filename = fullfile(dirName,[fxnname fsuffix]);
% end filename creation

% check for function vs. class and add default superclasses if necessary
d7 = str2double(description{parsePrompt.Type});
if isnan(d7)
  superclass = description{parsePrompt.Type};
  isClass = true;
elseif d7 == 2 || d7 == 3
  isClass = true;
  superclass = superclass{d7-1};
else
  isClass = false;
end

if ~isClass % it's a function
  % beginning of file-printing stage
  fid = fopen(filename,'wt');
  fprintf(fid,'function %s\n',synopsis);
  fprintf(fid,'%%%s\n',desc);
  fprintf(fid,'%%\n');
  fprintf(fid,'%% SYNOPSIS: %s\n',synopsis);
  fprintf(fid,'%%\n');
  fprintf(fid,['%% INPUT ',inputtext,'\n']);
  fprintf(fid,'%%\n');
  fprintf(fid,['%% OUTPUT ',outputtext,'\n']);
  fprintf(fid,'%%\n');
  fprintf(fid,'\n');
  fprintf(fid,'%% created with MATLAB ver.: %s\n',vers);
  fprintf(fid,'%% on %s\n',os);
  fprintf(fid,'%%\n');
  fprintf(fid,'%% Author: %s, %s\n',username, datetoday);
  fprintf(fid,'%% UPDATED: %s\n',datenow);
  fprintf(fid,'%%\n');
  fprintf(fid,'%% HISTORY\n');
  fprintf(fid,'%% yyyy-dd-mm\twhoami\tlog\n');
  fprintf(fid,'%% %s\t%s\tCreated it.\n', datetoday, username);
  fprintf(fid,'%% \n');
  fprintf(fid,'%% \n');
  fprintf(fid,'%% Copyright %s by %s <%s>\n',datestr(now, 'yyyy'),username, email);
  fprintf(fid, selectedLicense);
  fprintf(fid,'%s\n',repmat('%',1,75));
  fprintf(fid,'\n');
  fprintf(fid,'end');
  fclose(fid);
  % end of file-printing stage
else % it's a class
  fid = fopen(filename,'wt');
  fprintf(fid,'%%%s\n',desc);
  fprintf(fid,'%%\n');
  fprintf(fid,'%% CONSTRUCTOR: %s\n',synopsis);
  fprintf(fid,['%%   IN : ',inputtext,'\n']);
  fprintf(fid,['%%   OUT: ',outputtext,'\n']);
  fprintf(fid,'%%\n');
  fprintf(fid,'%% PROPERTIES\n');
  fprintf(fid,'%%   #property1:\n');
  fprintf(fid,'%%\n');
  fprintf(fid,'%% METHODS\n');
  fprintf(fid,'%%   #method1: short description\n');
  fprintf(fid,'%%        out = method1(obj,in)\n');
  fprintf(fid,'%%        Description of input and output\n');
  fprintf(fid,'%%\n');
  fprintf(fid,'%% created with MATLAB ver.: %s\n' ,os);
  fprintf(fid,'%% on %s\n',os);
  fprintf(fid,'%%\n');
  fprintf(fid,'%% Author: %s, %s\n',username, datetoday);
  fprintf(fid,'%% UPDATED: %s\n',datenow);
  fprintf(fid,'%%\n');
  fprintf(fid,'%% HISTORY\n');
  fprintf(fid,'%% yyyy-dd-mm\twhoami\tlog\n');
  fprintf(fid,'%% %s\t%s\tCreated it.\n', datetoday, username);
  fprintf(fid,'%% \n');
  fprintf(fid,'%% \n');
  fprintf(fid,'%% Copyright %s by %s <%s>\n',datestr(now, 'yyyy'),username, email);
  fprintf(fid, selectedLicense);
  fprintf(fid,'%s\n',repmat('%',1,75));
  % subclass myClass or myHandle by default
  if ~isempty(superclass)
    fprintf(fid,'\nclassdef %s < %s\n\nend',fxnname,superclass); %#ok<PFCEL>
  else
    fprintf(fid,'\nclassdef %s\n\nend',fxnname);
  end
  fclose(fid);
end

% pop up the newly generated file
edit(filename);
end

function name = username2name(username)
if ismember(lower(username),{'hty', 'HTY'})
  name = 'Hormetjan Yiltiz';
end
end

function itext = parseInvisible(itext)
% add line breaks if necessary, turn into single line of text
if size(itext,1) > 1
  itext = [itext,repmat('\n',size(itext,1),1)];
  itext(end,end-1:end) = ' ';
  itext = itext';
  itext = itext(:)';
  % kill some white space
  itext = regexprep(itext,'(\s*)\\n','\\n');
end
if strfind(itext,'\n')
  itext = regexprep(itext,'\\n','\\n%%\\t\\t');
end
end

function licensetext = selectLicense(whichLicense)
switch whichLicense
  case {'GPL', 'GNU GPL', 'GPLv3', 'GPLv3+'}
    licensetext = sprintf(['%%%% This program is free software: you can redistribute it and/or modify\n'...
      '%%%% it under the terms of the GNU General Public License as published by\n'...
      '%%%% the Free Software Foundation, either version 3 of the License, or\n'...
      '%%%% (at your option) any later version.\n'...
      '%%%% \n'...
      '%%%% This program is distributed in the hope that it will be useful,\n'...
      '%%%% but WITHOUT ANY WARRANTY; without even the implied warranty of\n'...
      '%%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n'...
      '%%%% GNU General Public License for more details.\n'...
      '%%%% \n'...
      '%%%% You should have received a copy of the GNU General Public License\n'...
      '%%%% along with this program.  If not, see <http://www.gnu.org/licenses/>.\n']);

  case {'BSD', 'BSD 3-Clause', 'BSD New'}
    licensetext = sprintf(['%%%% All rights reserved.\n'...
      '%%%% \n'...
      '%%%% Redistribution and use in source and binary forms, with or without\n'...
      '%%%% modification, are permitted provided that the following conditions are met:\n'...
      '%%%% \n'...
      '%%%% 1. Redistributions of source code must retain the above copyright notice, this\n'...
      '%%%% list of conditions and the following disclaimer.\n'...
      '%%%% \n'...
      '%%%% 2. Redistributions in binary form must reproduce the above copyright notice,\n'...
      '%%%% this list of conditions and the following disclaimer in the documentation\n'...
      '%%%% and/or other materials provided with the distribution.\n'...
      '%%%% \n'...
      '%%%% 3. Neither the name of the copyright holder nor the names of its contributors\n'...
      '%%%% may be used to endorse or promote products derived from this software without\n'...
      '%%%% specific prior written permission.\n'...
      '%%%% \n'...
      '%%%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"\n'...
      '%%%% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE\n'...
      '%%%% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE\n'...
      '%%%% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE\n'...
      '%%%% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL\n'...
      '%%%% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR\n'...
      '%%%% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER\n'...
      '%%%% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\n'...
      '%%%% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE\n'...
      '%%%% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n']);

  case {'MIT', 'Expat'}
    licensetext = sprintf(['%%%% Permission is hereby granted, free of charge, to any person obtaining a copy\n'...
      '%%%% of this software and associated documentation files (the "Software"), to deal\n'...
      '%%%% in the Software without restriction, including without limitation the rights\n'...
      '%%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n'...
      '%%%% copies of the Software, and to permit persons to whom the Software is\n'...
      '%%%% furnished to do so, subject to the following conditions:\n'...
      '%%%% \n'...
      '%%%% The above copyright notice and this permission notice shall be included in all\n'...
      '%%%% copies or substantial portions of the Software.\n'...
      '%%%% \n'...
      '%%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n'...
      '%%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n'...
      '%%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n'...
      '%%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n'...
      '%%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n'...
      '%%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n'...
      '%%%% SOFTWARE.\n']);

  otherwise
    licensetext = sprintf(['%%%% All rights reserved.\n'...
      '%%%% Unauthorized copying of this file, via any medium is strictly prohibited\n'...
      '%%%% Proprietary and confidential\n']);

end
end
