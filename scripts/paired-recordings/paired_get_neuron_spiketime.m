function varargout = paired_get_neuron_spiketime(neuron)
% [t1, waveform1]                          = paired_get_neuron_spiketime(neuron)
% [t1, t2, waveform1, waveform2]           = paired_get_neuron_spiketime(neuron)
% [t1, ..., tN, waveform1, ..., waveformN] = paired_get_neuron_spiketime(neuron)

expr_fname = [get_default_experiment_dir() neuron.experiment_filename];
expr = ScExperiment.load_experiment(expr_fname);

file = get_item(expr.list, neuron.file_tag);

waveforms = file.get_waveforms();

tmin = neuron.tmin;
tmax = neuron.tmax;

varargout = cell(2*length(neuron.template_tag), 1);

for i=1:length(neuron.template_tag)
  
  waveform = get_item(waveforms, neuron.template_tag{i});
  waveform.sc_loadtimes();
  
  spiketime = waveform.gettimes(tmin, tmax);
  %spiketime = extract_within_sequence(spiketime, neuron.time_sequences);
  
  varargout(i) = {spiketime};
  varargout(length(neuron.template_tag)+i) = {waveform};

end