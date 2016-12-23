function plot_mda(y, neurons)

cla
hold on
grid on

for i=1:size(y,1)
  plot(y(i,1), y(i,2), '.', 'MarkerSize', 12, 'Tag', neurons(i).file_str)
end

hold off

end
