function draw = initializeDraw(draw, typeStr, objectStruct)
switch typeStr
case {'circle'}
    draw.circle.coor= [draw.circle.coor; objectStruct.coor];
    draw.circle.color= [draw.circle.color; objectStruct.color];
    draw.circle.r= [draw.circle.r; objectStruct.r];
    draw.circle.width= [draw.circle.width; objectStruct.width];
    draw.circle.isFill= [draw.circle.isFill; objectStruct.isFill];

case {'poly'}
    draw.poly.coor= [draw.poly.coor; objectStruct.coor];
    draw.poly.color= [draw.poly.color; objectStruct.color];
    draw.poly.nPoints= [draw.poly.nPoints; objectStruct.nPoints]; % group poly.points according to the rows of nPointdraw.poly.nPoints 
    draw.poly.points= [draw.poly.points; objectStruct.points];   % each row does NOT necessarily belong to a seperate polygodraw.poly.points 
    draw.poly.width= [draw.poly.width; objectStruct.width];
    draw.poly.isFill= [draw.poly.isFill; objectStruct.isFill];

case {'line'}
    draw.line.coor= [draw.line.coor; objectStruct.coor];
    draw.line.orientation= [draw.line.orientation; objectStruct.orientation];
    draw.line.len= [draw.line.len; objectStruct.len];
    draw.line.width= [draw.line.width; objectStruct.width];
    draw.line.color= [draw.line.color; objectStruct.color];

case {'fix'}
    draw.fix.coor= [draw.fix.coor; objectStruct.coor];
    draw.fix.type= [draw.fix.type; objectStruct.type];
    draw.fix.r= [draw.fix.r; objectStruct.r];
    draw.fix.width= [draw.fix.width; objectStruct.width];
    draw.fix.color= [draw.fix.color; objectStruct.color];
    
    otherwise
    error('insertObject:UnknownObject', 'Object %s is not implemented or unknown', typeStr);
end
    
    

end
