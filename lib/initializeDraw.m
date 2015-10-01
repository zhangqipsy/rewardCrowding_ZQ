function draw = initializeDraw()
    draw.circle.coor =[];
    draw.circle.color =[];
    draw.circle.r =[];
    draw.circle.width =[];
    draw.circle.isFill =[];

    draw.poly.coor =[];
    draw.poly.color =[];
    draw.poly.nPoints = []; % group poly.points according to the rows of nPoints
    draw.poly.points =[];   % each row does NOT necessarily belong to a seperate polygon
    draw.poly.width =[];
    draw.poly.isFill =[];

    draw.line.coor =[];
    draw.line.orientation =[];
    draw.line.len =[];
    draw.line.width =[];
    draw.line.color =[];

    draw.fix.coor =[];
    draw.fix.type =[];
    draw.fix.r =[];
    draw.fix.width =[];
    draw.fix.color =[];

end
