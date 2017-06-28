function [xmean, xstd, xconf, xn] = sc_get_confint(x)

xn = length(x);
xstd = std(x);
xmean = mean(x);

sem = xstd/sqrt(xn);               
ts = tinv([0.025  0.975], xn - 1); 
xconf = xmean + ts*sem;            

end