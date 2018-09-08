close all
clear
sc_settings.set_current_settings_tag('temporary')
paired_load_settings();
paired_load_constants();

% 1A Example triplet = CFNR0003

% Plotta all spTKDE:s, hitta vilka cellpar som motsvarar 3A och koppla till 3B 
paired_perispike(ec_neurons, ec_pretrigger, ec_posttrigger, ec_kernelwidth, ec_min_stim_latency, ec_max_stim_latency, isi_min_spike_latency);
%Räkna ut stress för MDS
paired_mds(ec_neurons); % todo: change from cmdscale to mdscale in function, (the latter outputs stress)
mxfigs
cd ('C:\Users\Admin\Desktop\Hannes bilder')
save_as_png(get_all_figures())