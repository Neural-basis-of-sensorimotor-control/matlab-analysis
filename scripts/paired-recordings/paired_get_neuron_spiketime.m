function varargout = paired_get_neuron_spiketime(neuron, template_tag)
% [t1, waveform1]                          = paired_get_neuron_spiketime(neuron)
% [t1, t2, waveform1, waveform2]           = paired_get_neuron_spiketime(neuron)
% [t1, ..., tN, waveform1, ..., waveformN] = paired_get_neuron_spiketime(neuron)

expr       = ScExperiment.load_experiment(expr_fname);

file       = get_item(expr.list, neuron.file_tag);
waveforms  = file.get_waveforms();

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

enc_waveforms  = cell(size(template_tag));
enc_spiketimes = cell(size(template_tag));

for i=1:length(template_tag)
  
  waveform = get_item(waveforms, template_tag{i});
  waveform.sc_loadtimes();
  
  enc_waveforms(i)  = {waveform};
  enc_spiketimes(i) = {waveform.gettimes(neuron.tmin, neuron.tmax)};

end

tmin = max(cell2mat(get_values(enc_spiketimes, @min)));
tmax = min(cell2mat(get_values(enc_spiketimes, @max)));

for i=1:length(template_tag)
  
  spiketimes        = enc_spiketimes{i};
  spiketimes        = spiketimes(spiketimes > tmin & spiketimes < tmax);
  varargout(i)      = {spiketimes};

end

varargout(length(template_tag)+1:end) = enc_waveforms;

end