% 'bintimes'                2001 x 1 vektor med tider för korrelationsgrafen
%
% 'freq_spont_triggered'    autokorrelation när man triggar den ena cellen på det andra cellens spikar, vid spontanaktivtet. 2001 x 28 matris, där varje rad motsvarar ett cellpar och varje kolumn motsvarar en tidpunkt enligt bintimes ovan
% 'freq_stim_triggered'     autokorrelation när man triggar den ena cellen på det andra cellens spikar, under stimulering.
% 'freq_total'              autokorrelation när man triggar den ena cellen på det andra cellens spikar, för all aktivitet. 
%
% 'nbr_of_all_spikes'       antal triggerpunkter för all aktivitet. 2 x 28 matris där varje rad motsvarar ett cellpar och varje kolumn triggningar av cell 1 respektive cell 2
% 'nbr_of_spont_spikes'     antal triggerpunkter för spontan aktivitet
% 'nbr_of_stim_spikes'      antal triggerpunkter under stimulering
%
% 'tags'                    cellnamn                  

clc
clear
reset_fig_indx
sc_settings.set_current_settings_tag(sc_settings.tags.DEFAULT)
sc_settings.get_default_experiment_dir()
sc_debug.set_mode(true)

pretrigger          = -1;
posttrigger         = 1;
kernelwidth         = 1e-3;
min_stim_latency    = 5e-4;
max_stim_latency    = .2;
max_trigger_latency = .01;
neurons             = paired_get_extra_neurons();

binwidth = 1e-4;

[~, bintimes] = sc_kernelfreq([], [], pretrigger, ...
  posttrigger, kernelwidth, binwidth);

dim = [length(bintimes) length(neurons)];

freq_total = nan(dim);
freq_stim_triggered = nan(dim);
freq_spont_triggered = nan(dim);

nbr_of_stim_spikes = nan(2, dim(2));
nbr_of_spont_spikes = nan(2, dim(2));
nbr_of_all_spikes = nan(2, dim(2));

for i=1:length(neurons)
  
  neuron = neurons(i);
  
  [spiketimes1, spiketimes2] = paired_get_neuron_spiketime(neuron);
  stim_times = paired_get_stim_times(neuron);
  stim_times = cell2mat(stim_times');
  
  [spiketimes1_stim, spiketimes1_spont] = ...
    paired_single_out_spont_spikes(spiketimes1,  stim_times, ...
    min_stim_latency, max_stim_latency);
  
  [spiketimes2_stim, spiketimes2_spont] = ...
    paired_single_out_spont_spikes(spiketimes2,  stim_times, ...
    min_stim_latency, max_stim_latency);
  
  freq_total(:, i) = sc_kernelfreq(spiketimes1, spiketimes2, pretrigger, ...
    posttrigger, kernelwidth, binwidth)';
  
  freq_stim_triggered(:, i) = sc_kernelfreq(spiketimes1, spiketimes2_stim, pretrigger, ...
    posttrigger, kernelwidth, binwidth)';
  
  freq_spont_triggered(:, i) = sc_kernelfreq(spiketimes1, spiketimes2_spont, pretrigger, ...
    posttrigger, kernelwidth, binwidth)';
  
  nbr_of_all_spikes(:, i) = [length(spiketimes1) length(spiketimes2)]';
  nbr_of_stim_spikes(:, i) = [length(spiketimes1_stim) length(spiketimes2_stim)]';
  nbr_of_spont_spikes(:, i) = [length(spiketimes1_spont) length(spiketimes2_spont)]';
  
end
tags = {neurons.file_tag};

fprintf('              Total         Stim           Spont\n');
fprintf('Cell         N1     N2      N1  N2       N1    N2\n\n')

for i=1:length(tags)
  
  fprintf('%s\t%d\t%d\t%d\t%d\t%d\t%d\n', ...
    tags{i}, ...
    nbr_of_all_spikes(1, i), nbr_of_all_spikes(2, i), ...
    nbr_of_stim_spikes(1, i), nbr_of_stim_spikes(2, i), ...
    nbr_of_spont_spikes(1, i), nbr_of_spont_spikes(2, i));

end

fig = incr_fig_indx();
clf reset

for i=1:length(neurons)
  
  sc_square_subplot(length(neurons), i);
  hold on
  plot(bintimes, freq_total(:, i), 'Tag', 'all')
  plot(bintimes, freq_stim_triggered(:, i), 'Tag', 'stimulation')
  plot(bintimes, freq_spont_triggered(:, i), 'Tag', 'spontaneous')
  title(tags{i})
  
end

add_legend(fig, true);
