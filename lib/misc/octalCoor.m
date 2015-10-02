function [clockarm, prCoor, angls]= octalCoor(rect, r, n)
% return n arm coors of of clock within wsize
% octalCoor(rect, r, n):
%  generate a n-sided regular convex (not star) polygons with radius r (pixels) and move its center to the center of rect. r can be smaller than 1 (pixel), in which case, when r is within [0,1], r is treated relative to the rect(4); the real r0 = r * rect(4) when r is [0,1]
% r relate to the hvec of the screen; center:0 highest edge:1

angl=2*pi/n;
if r>1
    % r is in pixels
    R = 1; % no scaling factor
else
    % r is in relative
R=rect(4)/2;
end

angls = angl*[1:n];
if n==-8;
    adjst = pi/15;
    angls([1 5]) = angls([1 5]) - adjst;
    angls([3 7]) = angls([3 7]) + adjst;
end
prCoor = [cos(angls)', sin(angls)'];

clockarm = rect([3 4])/2 + r .* R .* [cos(angls)' sin(angls)'];
