function [rt, response] = collectResponse(responseSet, deadline, t0)
%FUNCTION [rt, response] = collectResponse(responseSet,  deadline, t0)
% collect keyboard response: 
% wait for key in response set, return response time relative to t0 and symbolic name of key
% if no key from response set is pressed, collectResponse returns deadline seconds after t0
% ...
% responseSet: cell array, set of symbolic names of response keys, as obtained by KbName
% deadline: (desired) presentation time of target (in seconds)
% t0: start presentation of last stimulus
% ...
% rt: reaction time (seconds)
% response: symbolic name of key pressed
% ...
% example call: 
% myResponseSet = {'LeftArrow', 'RightArrow'};
% t0 = GetSecs();
% collectResponse(myResponseSet, 2.0, t0)
% ...
% Jochen Laubrock wrote it

persistent keyIsDown t00 secs keyCode deltaSecs

responseSetCodes = KbName(responseSet);

keyIsDown = true;
while keyIsDown
    [keyIsDown, t00, keyCode, deltaSecs] = KbCheck();
end
done = false;
while ~done
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    if keyIsDown && sum(keyCode)==1 % only a single key pressed
        if any(keyCode(responseSetCodes))
            rt = secs - t0;
            response = KbName(keyCode);
            done = true;
        end
    elseif secs - t0 > deadline
        rt = -99.99;
        response = 'DEADLINE';
        done = true;
    end
end