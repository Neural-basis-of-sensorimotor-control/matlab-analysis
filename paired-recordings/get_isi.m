function [isi, times] = get_isi(neuron)

if isa(neuron, 'ScWaveform')
  times = neuron.gettimes(0,inf);
elseif isnumeric(neuron)
  times = neuron;
else
  error('Illegal input type: %s', class(neuron));
end

isi = diff(times);
isi = isi(:);

end