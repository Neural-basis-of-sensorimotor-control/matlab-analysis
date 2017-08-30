function [isi, bintimes, n] = sc_isi(spiketimes, binwidth, tmax)

isi = diff(spiketimes);

if nargin<3
  tmax = max(isi);
end

if length(tmax)>1
  tmin = tmax(1);
  tmax = tmax(2);
else
  tmin = 0;
end

edges    = (tmin:binwidth:tmax);
bintimes = edges(1:end-1) + binwidth/2;

isi = isi(isi >= tmin & isi <= tmax);
isi = histcounts(isi, edges); 
n   = sum(isi);
isi = isi / n;

end

