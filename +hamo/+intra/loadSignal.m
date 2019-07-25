function signal = loadSignal(neuron)

oldSignal = sc_load_signal(neuron);
signal = hamo.intra.Signal(oldSignal.parent, oldSignal.channelname);

hamo.util.clone(oldSignal, signal);

end