clc
clear
n = 100;
x = rand(n, 1);

stddev1 = sqrt(sum((x-mean(x)).^2))
stddev2 = stddev1/sqrt(n-1)
stddev3 = stddev1/sqrt(n)
stddev4 = stddev1/(n-1)

stddev2 - std(x)
stddev2 - std(x, 0)
stddev3 - std(x, 1)