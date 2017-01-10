function y = polynomial_filt(x, polynomial_nbr, width_indx)

if nargin < 2
  polynomial_nbr = 18;
end

if nargin < 3
  width_indx = 2e4;
end

y = nan(size(x));

for i=1:width_indx:length(x)
  
  indx = (i-1 + (1:width_indx))';
  indx(indx>length(x)) = [];
  
  [p, ~, mu] = polyfit(indx, x(indx), polynomial_nbr);
  
  y(indx) = x(indx) - polyval(p, indx, [], mu);
  
end

end