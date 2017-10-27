clear
close all

for i=1:10
  
  %x    = [rand(2,1); rand(2,1)+.5];
  %tags = {'a', 'a', 'b', 'b'};
  x = rand(10, 1);
  y = rand(5, 1)+.5;
  
  x_tags = cellfun(@(~) 'a', cell(size(x)) );
  y_tags = cellfun(@(~) 'y', cell(size(y)) );
  
  tags = [x_tags; y_tags];
  m    = [x; y];
  
  if size(tags, 1) ~= 1 && size(tags, 2) ~=  1
    error('wrong matrix dimension')
  end
  
  if size(m, 1) ~= 1 && size(m, 2) ~=  1
    error('wrong matrix dimension')
  end
  
  p1 = anova1(m, tags, 'off');
  p2 = ranksum(x, y);
  
  fprintf('%f\t%f\n', p1, p2)
  
end
% n = 1000;
%
% x = rand(n, 1);
%
% tag = cell(size(x));
%
% for i=1:n
%   tag(i) = {'a'};
% end
%
% for i=(n/2):2:n
%   tag(i) = {char(i)};
%   tag(i+1) = {char(i)};
%   x(i) = x(i);
% end
%
% x(n) = x(n) + 10;
%
% tag = tag(1:length(x));
%
% %
% % for i=1:n
% %   tag(i) = {'a'};
% % end
% %
% % for i=(n-3):n
% %   tag(i) = {'b'};
% %   x(i) = x(i);
% % end
% %
% % for i=n:n
% %   tag(i) = {'c'};
% %   x(i) = x(i);
% % end
% %
%
% p = anova1(x, tag)