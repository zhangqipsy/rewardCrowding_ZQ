function jitter = myRand(low, high)
% produce the jitter time such as myRand(1,3)
% 150422 by whx
jitter = low + rand() * (high - low);
end
