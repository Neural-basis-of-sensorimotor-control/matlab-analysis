function [isi, times] = get_isi(neuron)

times = neuron.gettimes(0,inf);

isi = diff(times);
isi = isi(:);

end