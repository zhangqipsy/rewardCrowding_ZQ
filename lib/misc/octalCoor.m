function [clockarm, prCoor, angls]= octalCoor(rect, r, n)
% return n arm coors of of clock within wsize
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

clockarm = rect([3 4])/2 .* r .* R .* [cos(angls)' sin(angls)'];
