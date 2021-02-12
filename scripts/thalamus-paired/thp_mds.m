function stress = thp_mds(neurons)

nbr_of_params  = 9;
nbr_of_neurons = 2*length(neurons);

values            = nan(nbr_of_params, nbr_of_neurons);
legend_str        = cell(nbr_of_neurons, 1);
markers           = cell(nbr_of_neurons, 1);
[~, layer_enumeration] = paired_get_layer();
layer_enumeration(end+1) = {'layer not found'};
right_click_fcns  = {};

for i_paired_neuron=1:length(neurons)
  
  tmp_paired_neuron = neurons(i_paired_neuron);
  
  for i_neuron=1:2
    
    col_indx             = i_paired_neuron * 2 + i_neuron - 2;
    legend_str(col_indx) = {tmp_paired_neuron.file_tag};
   
    try
        layer = paired_get_layer(tmp_paired_neuron);
    catch exc
        disp(exc.message)
        layer = layer_enumeration(end);
    end
    
    switch find(cellfun(@(x) strcmp(layer, x), layer_enumeration))
      
      case 1
        markers(col_indx)    = {'s'};
      case 2
        markers(col_indx)    = {'*'};
      otherwise
        markers(col_indx)    = {'+'};
          
      
    end
    
    counter = 0;
    
    [onset, ~, leading_flank_width, ~, trailing_flank_width, ~, peak_position] ...
      = tmp_paired_neuron.compute_all_distances('indx_prespike_response', i_neuron);
    
    tmp_values = [onset; leading_flank_width+trailing_flank_width; peak_position];%[normalized_height; onset; trailing_flank_width; peak_position];
    values(counter + (1:length(tmp_values)), col_indx) = tmp_values;
    counter = counter + length(tmp_values);
    
    [onset, ~, leading_flank_width, ~, trailing_flank_width, ~, ~, normalized_height] ...
      = tmp_paired_neuron.compute_all_distances('indx_perispike_response', i_neuron);
    
    tmp_values = [onset; leading_flank_width+trailing_flank_width; normalized_height];%[normalized_height; onset; trailing_flank_width; peak_position];
    values(counter + (1:length(tmp_values)), col_indx) = tmp_values;
    counter = counter + length(tmp_values);
    
    [~, ~, leading_flank_width, ~, trailing_flank_width, ~, ~, normalized_height] ...
      = tmp_paired_neuron.compute_all_distances('indx_postspike_response', i_neuron);
    
    tmp_values = [leading_flank_width+trailing_flank_width; leading_flank_width; normalized_height];%[normalized_height; onset; trailing_flank_width; peak_position];
    values(counter + (1:length(tmp_values)), col_indx) = tmp_values;
    counter = counter + length(tmp_values);
    
    if counter ~= size(values, 1)
      error('Wrong dimension of values matrix');
    end
    
    right_click_fcns = add_to_list(right_click_fcns, ...
      @(varargin) right_click_fcn(tmp_paired_neuron, i_neuron));
    
  end

end

mean_values = mean(abs(values), 2);
values      = values ./ repmat(mean_values, 1, nbr_of_neurons);

d = pdist(values');
[y, stress] = mdscale(d, 2);
incr_fig_indx()

msgs = cell(2*length(neurons), 1);
for i=1:length(neurons)
  msg = paired_get_cell_msg(neurons(i));
  msgs(2*i-1) = {msg};
  msgs(2*i)   = {msg};
end

clf
plot_mda(y, legend_str, markers, right_click_fcns, msgs);
add_legend();

end


function right_click_fcn(paired_neuron, neuron_indx)

figure
nbrws                  = NeuronBrowserClickRecorder(paired_neuron);
nbrws.neuron_pair_indx = neuron_indx;
nbrws.plot_neuron();

assignin('base', 'nbrws', nbrws);

end