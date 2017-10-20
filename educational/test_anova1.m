clear
close
n = 1000;

x = rand(n, 1);

tag = cell(size(x));

for i=1:n
  tag(i) = {'a'};
end

for i=(n/2):2:n
  tag(i) = {char(i)};
  tag(i+1) = {char(i)};
  x(i) = x(i);
end

x(n) = x(n) + 10;

tag = tag(1:length(x));

% 
% for i=1:n
%   tag(i) = {'a'};
% end
% 
% for i=(n-3):n
%   tag(i) = {'b'};
%   x(i) = x(i);
% end
% 
% for i=n:n
%   tag(i) = {'c'};
%   x(i) = x(i);
% end
% 

p = anova1(x, tag)