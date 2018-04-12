clc
% close all
% clear classes
% 
% sc_settings.set_current_settings_tag(sc_settings.tags.DEFAULT);
% sc_debug.set_mode(true);
% 
% ec_neurons = paired_get_extra_neurons();
% params     = paired_automatic_deflection_detection(ec_neurons);
% 
% [~, layer_enumeration] = paired_get_layer();
% 
% str_legend  = {};
% str_marker  = {};
% values      = [];
% is_layer_II = [];
% 
% for i=1:length(params)
%   
%   str_legend = add_to_list(str_legend, ec_neurons(i).file_tag);
%   str_legend = add_to_list(str_legend, ec_neurons(i).file_tag);
%   layer      = paired_get_layer(ec_neurons(i));
%   values     = [values params{i}{1} params{i}{2}]; %#ok<AGROW>
%   
%   tmp_layer_indx = find(cellfun(@(x) strcmp(layer, x), layer_enumeration));
%   
%   switch tmp_layer_indx
%     
%     case 1
%       tmp_marker = 's';
%     case 2
%       tmp_marker = '*';
%     otherwise
%       error('Incorrect layer label');
%   
%   end
%   
%   is_layer_II = add_to_list(is_layer_II, tmp_layer_indx == 1);
%   is_layer_II = add_to_list(is_layer_II, tmp_layer_indx == 1);
%   
%   str_marker = add_to_list(str_marker, tmp_marker);
%   str_marker = add_to_list(str_marker, tmp_marker);
%   
% end
% 
% mean_values = mean(abs(values), 2);
% normalized_values      = values ./ repmat(mean_values, 1, 2*length(ec_neurons));
% 
% d = pdist(normalized_values');
% y = cmdscale(d, 2);
% 
% incr_fig_indx()
% 
% clf
% plot_mda(y, str_legend, str_marker);
%%
sample_size = size(values, 2);
reorganized_values = values;
reorganized_values([3 7 11], :) = ...
  reorganized_values([3 7 11], :) + reorganized_values([1 5 9], :);

for i=1:size(values, 1)
  
  p          = ranksum(reorganized_values(i, is_layer_II), reorganized_values(i, ~is_layer_II));
  mean_value = mean(reorganized_values(i, :));
  std_value  = std(reorganized_values(i, :));
  coeff_var  = std_value / abs(mean_value);
  fprintf('%d\tP = %g\t%d\t%d\t%d\n', ...
    sample_size, p, round(1000*mean_value), round(1000*std_value), ...
    round(100*coeff_var));

end
  
