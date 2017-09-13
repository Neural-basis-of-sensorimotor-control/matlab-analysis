function paired_plot_unitary_epsp_response(neuron, pretrigger, posttrigger, t_epsp_range, t_spike_range)

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_plot_unitary_epsp_response, neuron, pretrigger, posttrigger, t_epsp_range, t_spike_range);
  return
  
end

h_axes = [];

[sweeps, sweep_times, signal] = paired_get_sweeps(neuron, pretrigger, posttrigger);

if isempty(sweeps)
  fprintf('Skipping %s because no sweeps\n', neuron.file_tag);
  return
end

[~, zero_ind] = min(abs(sweep_times));

for i=1:size(sweeps, 2)
  sweeps(:,i) = sweeps(:,i) - sweeps(zero_ind, i);
end


sweeps_contain_xpsp  = paired_match_template(signal, sweeps, sweep_times, t_epsp_range, neuron.xpsp_tag);

if isempty(neuron.xpsp_tag)
  sweeps_contain_xpsp = true(size(sweeps_contain_xpsp));
end

sweeps_contain_spike = paired_match_template(signal, sweeps, sweep_times, t_spike_range, neuron.artifact_tag);

xpsp_sweeps         = sweeps(:, sweeps_contain_xpsp & ~sweeps_contain_spike);
spike_sweeps        = sweeps(:, sweeps_contain_spike);
antiselected_sweeps = sweeps(:, ~sweeps_contain_xpsp & ~sweeps_contain_spike);

title_str = sprintf('%s - %s (%s) comment: %s', neuron.file_tag, neuron.signal_tag, neuron.template_tag{1}, neuron.comment);

fig    = incr_fig_indx();
clf

if ~isempty(xpsp_sweeps)
  
  plot(sweep_times, xpsp_sweeps, 'ButtonDownFcn', @(src, ~) make_thick(src));
  h_axes = add_to_list(h_axes, gca);

else
  
  cla

end

set_userdata(fig, 'neuron', neuron);

title([title_str ' XPSP'])
paired_add_neuron_textbox(neuron);

fig    = incr_fig_indx();
clf

if ~isempty(spike_sweeps)
  
  plot(sweep_times, spike_sweeps, 'ButtonDownFcn', @(src, ~) make_thick(src));
  h_axes = add_to_list(h_axes, gca);

else
  
  cla

end

set_userdata(fig, 'neuron', neuron);

title([title_str ' spike'])
paired_add_neuron_textbox(neuron);

fig    = incr_fig_indx();
clf

if ~isempty(antiselected_sweeps)
  
  plot(sweep_times, antiselected_sweeps, 'ButtonDownFcn', @(src, ~) make_thick(src));
  h_axes = add_to_list(h_axes, gca);

else
  
  cla

end

set_userdata(fig, 'neuron', neuron);

title([title_str ' antiselected'])
paired_add_neuron_textbox(neuron);

linkaxes(h_axes);

end


