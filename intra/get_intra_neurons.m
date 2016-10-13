function neurons = get_intra_neurons()

neurons(1).expr_file = 'IHNR_sc.mat';    neurons(1).file_str = 'IHNR0000';     neurons(1).signal_str = 'patch';   neurons(1).tag = 'Neuron01';
neurons(2).expr_file = 'HPNR_sc.mat';    neurons(2).file_str = 'HPNR0003';     neurons(2).signal_str = 'patch2';  neurons(2).tag = 'Neuron02';
neurons(3).expr_file = 'IKNR_sc.mat';    neurons(3).file_str = 'IKNR0000';     neurons(3).signal_str = 'patch';   neurons(3).tag = 'Neuron03';
neurons(4).expr_file = 'IFNR_sc.mat';    neurons(4).file_str = 'IFNR0004';     neurons(4).signal_str = 'patch';   neurons(4).tag = 'Neuron04';
neurons(5).expr_file = 'ILNR_sc.mat';    neurons(5).file_str = 'ILNR0001';     neurons(5).signal_str = 'patch';   neurons(5).tag = 'Neuron05';
neurons(6).expr_file = 'IFNR_sc.mat';    neurons(6).file_str = 'IFNR0002';     neurons(6).signal_str = 'patch';   neurons(6).tag = 'Neuron06';
neurons(7).expr_file = 'IHNR_sc.mat';    neurons(7).file_str = 'IHNR0001';     neurons(7).signal_str = 'patch';   neurons(7).tag = 'Neuron07';
neurons(8).expr_file = 'ICNR_sc.mat';    neurons(8).file_str = 'ICNR0003';     neurons(8).signal_str = 'patch';   neurons(8).tag = 'Neuron08';
neurons(9).expr_file = 'ICNR_sc.mat';    neurons(9).file_str = 'ICNR0002';     neurons(9).signal_str = 'patch';   neurons(9).tag = 'Neuron09';
neurons(10).expr_file = 'HRNR_sc.mat';   neurons(10).file_str = 'HRNR0000';    neurons(10).signal_str = 'patch2'; neurons(10).tag = 'Neuron10';
neurons(11).expr_file = 'BENR_sc.mat';   neurons(11).file_str = 'BENR0005';    neurons(11).signal_str = 'patch'; neurons(11).tag = 'NeuronXX';
neurons(12).expr_file = 'BJNR_sc.mat';   neurons(12).file_str = 'BJNR0005';    neurons(12).signal_str = 'patch'; neurons(12).tag = 'NeuronXX';
neurons(13).expr_file = 'BONR_sc.mat';   neurons(13).file_str = 'BONR0009';    neurons(13).signal_str = 'patch'; neurons(13).tag = 'NeuronXX';
neurons(14).expr_file = 'BONR_sc.mat';   neurons(14).file_str = 'BONR0006';    neurons(14).signal_str = 'patch'; neurons(14).tag = 'NeuronXX';
neurons(15).expr_file = 'CCNR_sc.mat';   neurons(15).file_str = 'CCNR0000';    neurons(15).signal_str = 'patch'; neurons(15).tag = 'NeuronXX';
neurons(16).expr_file = 'CANR_sc.mat';   neurons(16).file_str = 'CANR0008';    neurons(16).signal_str = 'patch'; neurons(16).tag = 'NeuronXX';
neurons(17).expr_file = 'CANR_sc.mat';   neurons(17).file_str = 'CANR0001';    neurons(17).signal_str = 'patch'; neurons(17).tag = 'NeuronXX';
neurons(18).expr_file = 'BPNR_sc.mat';   neurons(18).file_str = 'BPNR0000';    neurons(18).signal_str = 'patch'; neurons(18).tag = 'NeuronXX';
neurons(19).expr_file = 'BPNR_sc.mat';   neurons(19).file_str = 'BPNR0001';    neurons(19).signal_str = 'patch'; neurons(19).tag = 'NeuronXX';
neurons(20).expr_file = 'BNNR_sc.mat';   neurons(20).file_str = 'BNNR0007';    neurons(20).signal_str = 'patch'; neurons(20).tag = 'NeuronXX';
neurons(21).expr_file = 'BKNR_sc.mat';   neurons(21).file_str = 'BKNR0002';    neurons(21).signal_str = 'patch'; neurons(21).tag = 'NeuronXX';
neurons(22).expr_file = 'BKNR_sc.mat';   neurons(22).file_str = 'BKNR0000';    neurons(22).signal_str = 'patch'; neurons(22).tag = 'NeuronXX';
neurons(23).expr_file = 'BHNR_sc.mat';   neurons(23).file_str = 'BHNR0002';    neurons(23).signal_str = 'patch'; neurons(23).tag = 'NeuronXX';
neurons(24).expr_file = 'BGNR_sc.mat';   neurons(24).file_str = 'BGNR0000';    neurons(24).signal_str = 'patch'; neurons(24).tag = 'NeuronXX';
neurons(25).expr_file = 'DJNR_sc.mat';   neurons(25).file_str = 'DJNR0005';    neurons(25).signal_str = 'patch'; neurons(25).tag = 'NeuronXX'; neurons(25).tmin = 900; neurons(25).tmax = inf;

neurons(26).expr_file = 'BPNRtst_sc.mat';   neurons(26).file_str = 'BPNR0000';    neurons(26).signal_str = 'patch'; neurons(26).tag = 'NeuronXX';
neurons(27).expr_file = 'BPNRtst_sc.mat';   neurons(27).file_str = 'BPNR0001';    neurons(27).signal_str = 'patch'; neurons(27).tag = 'NeuronXX';

end
