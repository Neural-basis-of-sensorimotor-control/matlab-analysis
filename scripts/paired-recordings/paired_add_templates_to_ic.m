function paired_add_templates_to_ic(neuron, pretrigger, posttrigger, t_range)

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_add_templates_to_ic, neuron, pretrigger, posttrigger, t_range);
  return
  
end

[sweeps, sweep_times, signal] = paired_get_sweeps(neuron, pretrigger, posttrigger);

if isempty(sweeps)
  fprintf('Skipping %s because no sweeps\n', neuron.file_tag);
  return
end

[~, zero_ind] = min(abs(sweep_times));

for i=1:size(sweeps, 2)
  sweeps(:,i) = sweeps(:,i) - sweeps(zero_ind, i);
end

sweeps_contain_xpsp  = paired_match_template(signal, sweeps, sweep_times, t_range, neuron.xpsp_tag);

if isempty(neuron.xpsp_tag)
  sweeps_contain_xpsp = true(size(sweeps_contain_xpsp));
end

sweeps_contain_spike = paired_match_template(signal, sweeps, sweep_times, [min(t_range(1), 0) t_range(2)], neuron.artifact_tag);

xpsp_sweeps         = sweeps(:, sweeps_contain_xpsp & ~sweeps_contain_spike);
%spike_sweeps        = sweeps(:, sweeps_contain_spike);
%antiselected_sweeps = sweeps(:, ~sweeps_contain_xpsp & ~sweeps_contain_spike);

title_str = sprintf('%s - %s (%s) comment: %s', neuron.file_tag, neuron.signal_tag, neuron.template_tag{1}, neuron.comment);

incr_fig_indx();

fprintf('%s\n', title_str)

DefineThreshold.define(xpsp_sweeps, signal.dt);

end