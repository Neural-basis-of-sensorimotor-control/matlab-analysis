function sc_blank_fig(f)

if ~nargin
  f = gcf;
end

f.Color = '1 1 1';

ax = sc_get_axes(f);

for i=1:length(ax)
  ax(i).Box = 'Off';
end