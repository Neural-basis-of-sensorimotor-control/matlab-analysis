function [isi, bintimes, n] = sc_isi(spiketimes, binwidth, tmax)

isi = diff(spiketimes);

if nargin < 3
  tmax = max(isi);
end

edges    = (0:binwidth:tmax);
bintimes = edges(1:end-1) + binwidth/2;

isi = isi(isi <= tmax);
isi = histcounts(isi, edges); 
n   = sum(isi);
isi = isi / n;

end

