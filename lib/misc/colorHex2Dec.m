function colorDecCodes = colorHex2Dec(colorHexCodes)
% Here are valid codes
%    colorHexCodes = '315724'
%    colorHexCodes = '#315724'
%    colorHexCodes = ['#315724' '#315724'] 
colorDecCodes = reshape(hex2dec(cellstr(reshape(strrep(colorHexCodes, '#', '')', 2,[])')), 3, [])';
end
