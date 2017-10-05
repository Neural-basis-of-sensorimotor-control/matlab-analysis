function [onset, height, leading_flank_width, leading_flank_height, trailing_flank_width, trailing_flank_height, peak_position] ...
  = compute_all_distances(obj, str_property, indx_neuron)

x_            = obj.x{indx_neuron};
y_            = obj.y{indx_neuron};

indx         = obj.(str_property){indx_neuron};

x_           = x_(indx);
y_           = y_(indx);

if isempty(x_)
  
  onset                 = 0;
  height                = 0;
  leading_flank_width   = 0;
  leading_flank_height  = 0;
  trailing_flank_width  = 0;
  trailing_flank_height = 0;
  peak_position         = 0;
  
else
  
  onset = x_(1);
  
  if length(indx) == 3
    height = y_(2) - mean(y_(1) + y_(3));
  elseif length(indx) == 4
    height = mean(y_([2 3]) - y_([1 4]));
  else
    error('Wrong number of inputs');
  end
  
  leading_flank_width  = x_(2) - x_(1);
  leading_flank_height = y_(2) - y_(1);
  
  if length(indx) == 3
    trailing_flank_width = x_(3) - x_(2);
    trailing_flank_height = y_(3) - y_(2);
  elseif length(indx) == 4
    trailing_flank_width = x_(4) - x_(3);
    trailing_flank_height = y_(4) - y_(3);
  else
    error('Wrong number of inputs');
  end
  
  if length(indx) == 3
    peak_position = x_(2);
  elseif length(indx) == 4
    peak_position = mean(x_([2 3]));
  else
    error('Wrong number of inputs');
  end
  
end