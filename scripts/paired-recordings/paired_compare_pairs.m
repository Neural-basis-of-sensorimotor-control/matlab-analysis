function dist = paired_compare_pairs(neuron_pair_1, neuron_pair_2)

f1 = get_f(neuron_pair_1);
f2 = get_f(neuron_pair_2);

%dist = min(sum(abs(f1-f2)), sum(abs(f1-f2(length(f2):-1:1))));
dist = min(sqrt( sum( (f1-f2).^2 ) ), sqrt( sum( (f1-f2(length(f2):-1:1)).^2 )));

end


function f = get_f(neuron_pair)

pretrigger  = -1;
posttrigger = 1;
kernelwidth = 1e-3;
binwidth    = 1e-3;

[t1, t2] = paired_get_neuron_spiketime(neuron_pair);
f = sc_kernelfreq(t1, t2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
f = zscore(f);

end