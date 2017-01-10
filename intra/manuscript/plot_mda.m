function plot_mda(y, neurons)

cla
hold_is_on = ishold;

hold on
grid on

if size(y,2) == 2
  
  for i=1:size(y,1)
    plot(y(i,1), y(i,2), '.', 'MarkerSize', 12, 'Tag', neurons(i).file_str, ...
      'ButtonDownFcn', @print_tag)
  end
  xlabel('n_1'), ylabel('n_2')

elseif size(y,2) == 3
  
  for i=1:size(y,1)
    plot3(y(i,1), y(i,2), y(i,3), '.', 'MarkerSize', 12, 'Tag', neurons(i).file_str)
  end
  
  xlabel('n_1'), ylabel('n_2'), zlabel('n_3')
end

if ~hold_is_on
  hold off
end

end

function print_tag(obj, ~)

disp(get(obj, 'Tag'));
x = get(obj, 'XData');
y = get(obj, 'YData');
text(x,y,get(obj,'Tag'))

end
