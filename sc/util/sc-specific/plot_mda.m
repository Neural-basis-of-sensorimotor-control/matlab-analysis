function plot_mda(y, neuron_tags, markers, right_click_fcns)

dummy_cell = cell(size(y,1), 1);

if nargin<2
  
  neuron_tags = cellfun(@(x) '', dummy_cell, 'UniformOutput', false);
  
elseif ischar(neuron_tags)
  
  neuron_tags = cellfun(@(x) neuron_tags, dummy_cell, 'UniformOutput', false);
  
elseif ~iscell(neuron_tags)
  
  neuron_tags = {neurons.file_tag};
  
end

if nargin<3
  markers = cellfun(@(x) '.', dummy_cell, 'UniformOutput', false);
elseif ischar(markers)
  markers = cellfun(@(x) markers, dummy_cell, 'UniformOutput', false);
end

cla
hold_is_on = ishold;

hold on
grid on

if size(y,2) == 2
  
  for i=1:size(y,1)
    
    h_plot = plot(y(i,1), y(i,2), 'MarkerSize', 12, 'Tag', neuron_tags{i}, ...
      'Marker', markers{i}, 'ButtonDownFcn', @print_tag);
    
    if nargin >= 4
      set(h_plot, 'UiContextMenu', get_right_click_menu(right_click_fcns{i}));
    end
    
  end
  
  xlabel('n_1'), ylabel('n_2')
  
elseif size(y,2) == 3
  
  for i=1:size(y,1)
    
    plot3(y(i,1), y(i,2), y(i,3), '.', 'MarkerSize', 12, ...
      'Tag', neuron_tags{i}, 'Marker', markers{i})
    
  end
  
  xlabel('n_1'), ylabel('n_2'), zlabel('n_3')
  
end

if ~hold_is_on
  hold off
end

end


function print_tag(obj, ~)

disp(get(obj, 'Tag'));

if strcmp(obj.Parent.Parent.SelectionType, 'open')
  
  x = get(obj, 'XData');
  y = get(obj, 'YData');
  text(x,y,get(obj,'Tag'))
  
end

end

function c = get_right_click_menu(fcn)

c = uicontextmenu();

uimenu(c, 'Label', 'Edit parameters', 'Callback', ...
  @(~,~) fcn());

end