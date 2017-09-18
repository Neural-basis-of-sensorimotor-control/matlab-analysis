function distance = spkd(spike1, spike2, cost)
%
% d=spkd(tli,tlj,cost) calculates the "spike time" distance
% (Victor & Purpura 1996) for a single cost
%
% tli: vector of spike times for first spike train
% tlj: vector of spike times for second spike train
% cost: cost per unit time to move a spike
%
%  Copyright (c) 1999 by Daniel Reich and Jonathan Victor.
%  Translated to Matlab by Daniel Reich from FORTRAN code by Jonathan Victor.
%

% 2017: Code edited by Neural basis of sensorimotor function, Lund
% University

n_spike1 = length(spike1);
n_spike2 = length(spike2);

if cost == 0
  
  distance = abs(n_spike1 - n_spike2);
  return
  
elseif cost == Inf
  
  distance = n_spike1 + n_spike2;
  return
  
end

score = zeros(n_spike1+1, n_spike2+1);

%
%     INITIALIZE MARGINS WITH COST OF ADDING A SPIKE
%

score(:,1) = (0:n_spike1)';
score(1,:) = (0:n_spike2);

if n_spike1 && n_spike2
  
  for i=2:(n_spike1+1)
    
    for j=2:(n_spike2+1)
      
      score(i,j) = min([score(i-1, j) + 1 score(i, j-1) + 1 score(i-1, j-1) + cost * abs(spike1(i-1) - spike2(j-1))]);
      
    end
  end
end

distance = score(n_spike1+1, n_spike2 + 1);

end