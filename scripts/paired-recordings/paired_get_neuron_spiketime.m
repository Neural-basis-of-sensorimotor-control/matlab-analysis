function varargout = paired_get_neuron_spiketime(neuron, template_tag)
% [t1, waveform1]                          = paired_get_neuron_spiketime(neuron)
% [t1, t2, waveform1, waveform2]           = paired_get_neuron_spiketime(neuron)
% [t1, ..., tN, waveform1, ..., waveformN] = paired_get_neuron_spiketime(neuron)

expr_fname = [sc_settings.get_default_experiment_dir() neuron.experiment_filename];
expr       = ScExperiment.load_experiment(expr_fname);

file       = get_item(expr.list, neuron.file_tag);
waveforms  = file.get_waveforms();

tmin       = neuron.tmin;
tmax       = neuron.tmax;

varargout = cell(2*length(neuron.template_tag), 1);

if nargin < 2
  
  template_tag = neuron.template_tag;
  
elseif ischar(template_tag)
  
  template_tag = {template_tag};
  
elseif isnumeric(template_tag)
  
  template_tag = neuron.template_tag(template_tag);
  
else
  
  error('Unknown input type %s', class(template_tag));

end

for i=1:length(template_tag)
  
  waveform = get_item(waveforms, template_tag{i});
  waveform.sc_loadtimes();
  
  spiketime = waveform.gettimes(tmin, tmax);
  
  varargout(i) = {spiketime};
  varargout(length(template_tag)+i) = {waveform};

end