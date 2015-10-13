function colorDecCodes = colorHex2Dec(colorHexCodes)
% Here are valid codes
%    colorHexCodes = '315724'
%    colorHexCodes = '#315724'
%    colorHexCodes = ['#315724' '#315724'] 
%    colorHexCodes = ['#315724 #315724'] % Even this! Just copy paste your stuff
%    colorHexCodes = ['#315724 315724'] % Or this
%    colorHexCodes = ['315724 315724'] % Or this
%    colorHexCodes = ['315724315724  315724 315724'] % Or this
%    colorHexCodes = ['315724315724  315724 #315724'] % Anything that looks like someting that makes sense (yes, the first one is jammed!)
colorDecCodes = reshape(hex2dec(cellstr(reshape(regexprep(colorHexCodes, '[# ]', '')', 2,[])')), 3, [])';
end
