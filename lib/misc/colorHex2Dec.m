function colorDecCodes = colorHex2Dec(colorHexCodes)
% Here are valid codes
%    colorHexCodes = '315724'
%    colorHexCodes = '#315724'
%    colorHexCodes = ['#315724' '#315724'] 
%    colorHexCodes = ['#315724 #315724'] % Even this! Just copy paste your stuff
colorDecCodes = reshape(hex2dec(cellstr(reshape(regexprep(colorHexCodes, '[# ]', '')', 2,[])')), 3, [])';
end
