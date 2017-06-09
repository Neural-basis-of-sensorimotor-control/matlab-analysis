function intra_sanity_check_template_vs_manual(response_min, response_max, min_isi_on)
%Sanity check template EPSPs vs manual detection
reset_fig_indx();
sc_clf_all('reset');

neurons = get_intra_neurons();
stims = get_intra_motifs();

for i=1:length(neurons)
  fprintf('%d / %d\n', i, length(neurons));
  
  tmp_neuron = neurons(i);
  
  intra_sanity_check_1(tmp_neuron, stims, response_min, response_max, min_isi_on);
  
end

end


function intra_sanity_check_1(neuron, stims, response_min, response_max, min_isi_on)

signal = sc_load_signal(neuron);

template = signal.waveforms.get('tag', 'EPSP5');

amplitudes = get_items(signal.amplitudes.list, 'tag', stims);

max_length = min(arrayfun(@(x) length(amplitudes(x).stimtimes), 1:length(amplitudes)));

dim            = [max_length, length(stims)];
height         = nan(dim);
response_types = nan(dim);

for i=1:length(stims)
  
  tmp_stim = stims{i};
  
  [height(:, i), response_types(:, i)] = intra_sanity_check_2(signal, template, tmp_stim, response_min, response_max, min_isi_on, max_length);

end

incr_fig_indx();
hold on

fill_matrix(height, 'HitTest', 'off');
colorbar;

[x_, y_] = find(response_types == 0);
h_plot(1) = plot(x_, y_, 'k+', 'HitTest', 'off');
[x_, y_] = find(response_types == 1);
h_plot(2) = plot(x_, y_, 'k*', 'HitTest', 'off');

[x_, y_] = find(response_types == 2);
h_plot(3) = plot(x_, y_, 'ko', 'HitTest', 'off');

[x_, y_] = find(response_types == 3);
h_plot(4) = plot(x_, y_, 'k.', 'HitTest', 'off');

axis tight

y_tick_label = stims;

threshold = get_activity_threshold(signal);
response_is_included = arrayfun(@(x) x.userdata.fraction_detected >= threshold, amplitudes);

y_tick_label(response_is_included) = cellfun(@(x) ['\bf ' x], ...
  y_tick_label(response_is_included), 'UniformOutput', false);

set(gca, 'YTick', 1:length(stims), 'YTickLabel', y_tick_label);
title(neuron.file_tag)

legend(h_plot, 'no detection', 'only template', 'only manual', 'both');
set(gca, 'UserData', neuron, 'ButtonDownFcn', @btn_dwn_fcn)


incr_fig_indx()
hold on

for i=1:size(response_types, 2)
  
  val = arrayfun(@(x) nnz(response_types(:,i)==x)/max_length, 0:3);
  
  plot(i, val(1), 'k+')
  plot(i, val(2), 'r*')
  plot(i, val(3), 'go')
  plot(i, val(4), 'b.', 'MarkerSize', 14)

end

title(neuron.file_tag);
legend('no detection', 'only template', 'only manual', 'both');

x_tick_label = stims;

set(gca, 'XTick', 1:length(stims), 'XTickLabel', x_tick_label, ...
  'XTickLabelRotation', 270);

hold on

linkaxes(get_axes(gcf));

end


function [height, response_types] = intra_sanity_check_2(signal, template, stim, response_min, response_max, min_isi_on, max_length)

amplitude = signal.amplitudes.get('tag', stim);
indx = 1:max_length;

response_types = arrayfun(@(x) intra_sanity_check_3(amplitude, template, x, response_min, response_max, min_isi_on), ...
  indx);

height = amplitude.data(indx, 4) - amplitude.data(indx, 2);

end


function val = intra_sanity_check_3(amplitude, template, indx, response_min, response_max, min_isi_on)

template_detected = template.spike_is_detected(amplitude.stimtimes(indx) + response_min, amplitude.stimtimes(indx) + response_max, min_isi_on);
manually_detected = all(isfinite(amplitude.data(indx, [2 4])));

if ~template_detected && ~manually_detected
  val = 0;
elseif template_detected && ~manually_detected
  val = 1;
elseif ~template_detected && manually_detected
  val = 2;
elseif template_detected && manually_detected
  val = 3;
end
  
end
  
  
function btn_dwn_fcn(src, ~)

p = get(src, 'currentpoint');

stim_nbr   = round(p(1,2));
repetition = round(p(1,1));

if stim_nbr < 0 || repetition < 0
  return
end

neuron = get(src, 'UserData');

get_spiketrain_fcn = @(x) get_spiketrain(x, stim_nbr, neuron);

gui_mgr = neuron.load_experiment(get_spiketrain_fcn);

gui_mgr.viewer.set_triggerparent(gui_mgr.viewer.main_signal);
gui_mgr.viewer.set_trigger('dummy');
gui_mgr.viewer.set_sweep(repetition);


end


function spiketrain = get_spiketrain(signal, stim_nbr, neuron)

stim = get_intra_motifs(stim_nbr);
stim = stim{1};

amplitude = signal.amplitudes.get('tag', stim);
times = amplitude.gettimes(neuron.tmin, neuron.tmax);

spiketrain = ScSpikeTrain('dummy', times);

end


