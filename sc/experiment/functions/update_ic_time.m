clc
clear

neuron = get_intra_neurons(15);
%neuron = get_intra_neurons(25);

signal = sc_load_signal(neuron);
amplitudes = signal.amplitudes;

for i=1:amplitudes.n
  
  amplitude = amplitudes.get(i);
  indx = amplitude.stimtimes >= neuron.tmin & amplitude.stimtimes <= neuron.tmax;
  
  amplitude.stimtimes = amplitude.stimtimes(indx);
  amplitude.data = amplitude.data(indx, :);
  amplitude.automatic_xpsp_detected = amplitude.automatic_xpsp_detected(indx);
  
  fprintf('%d:\t %d\t (%d)\n', i, nnz(~indx), length(indx));
end
neuron.file_tag