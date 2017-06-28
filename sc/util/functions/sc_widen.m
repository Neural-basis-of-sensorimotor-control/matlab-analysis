function sc_widen(ax)

if ~nargin
  ax = gca;
end

for i=1:length(ax)
  xl = xlim(ax(i));
  xlim(ax(i), xl + [-1 1]);
end

end