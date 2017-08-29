function neurons = paired_get_extra_neurons()

data = {
	'BENR_sc.mat'	'BENR0002'	'patch'	6.979807e+01	1.652043e+03	{'spike2-double' 'spike1-double'}	
	'BKNR_SSSA_sc.mat'	'BKNR0000'	'patch'	3.220902e+01	6.536293e+02	{'spike1-double' 'spike2-double'}	
	'BKNR_SSSA_sc.mat'	'BKNR0000'	'patch'	2.022110e+02	6.536293e+02	{'spike1-double' 'spike3-double'}	
	'BKNR_SSSA_sc.mat'	'BKNR0000'	'patch'	2.022110e+02	1.136595e+03	{'spike2-double' 'spike3-double'}	
	'BKNR_SSSA_sc.mat'	'BKNR0002'	'patch'	5.140642e+02	1.202326e+03	{'spike1' 'spike2'}	
	'BKNR_SSSA_sc.mat'	'BKNR0002'	'patch'	5.111576e+02	1.202501e+03	{'spike1' 'ECspike'}	
	'BKNR_SSSA_sc.mat'	'BKNR0002'	'patch'	5.140642e+02	1.202326e+03	{'spike2' 'ECspike'}	
	'BMNR_SSSA_sc.mat'	'BMNR0000'	'patch'	5.099150e+00	1.645197e+03	{'spike1-double' 'spike2-double'}	
	'BMNR_SSSA_sc.mat'	'BMNR0006'	'patch'	2.590009e+02	1.094026e+03	{'spike1-double' 'spike2-double'}	
	'BPNR_sc.mat'	'BPNR0000'	'patch'	2.665700e-01	1.726884e+03	{'ic-spike-p1-1' 'ec-spike-p1-1'}	
	'BPNR_sc.mat'	'BPNR0001'	'patch'	3.332400e-01	4.960155e+02	{'ec-spike-p1-1' 'ic-spike-p1-2'}	
	'CENR_sc.mat'	'CENR0001'	'patch'	1.160372e+02	1.190190e+03	{'spike1-double' 'spike2-double'}	
	'CFNR_sc.mat'	'CFNR0003'	'patch'	1.217960e+00	1.177683e+03	{'spike1-double' 'spike2-double'}	
	'CHNR_sc.mat'	'CHNR0003'	'patch'	2.594170e+00	3.732582e+02	{'spike1-double' 'spike2-double'}	
	'CKNR_sc.mat'	'CKNR0001'	'patch'	1.802749e+02	1.294524e+03	{'spike1-double' 'spike2-double'}	
	'CNNR_sc.mat'	'CNNR0009'	'patch'	2.257300e-01	1.227414e+03	{'spike1-double' 'spike2-double'}	
	'DBNR_sc.mat'	'DBNR0000'	'patch'	1.184510e+02	4.717782e+02	{'spike1-double' 'spike2-double'}	
	'DBNR_sc.mat'	'DBNR0003'	'patch'	5.753400e-01	1.387524e+03	{'spike1-double' 'spike2-double'}	
	'DBNR_sc.mat'	'DBNR0001'	'patch'	9.856540e+00	1.912279e+03	{'spike1-double' 'spike2-double'}	
	'DENR_sc.mat'	'DENR0004'	'patch'	2.411000e-02	1.213339e+03	{'spike1-double' 'spike2-double'}	
	'DENR_sc.mat'	'DENR0004'	'patch'	1.072150e+00	1.118984e+03	{'spike1-double' 'spike3-double'}	
	'DENR_sc.mat'	'DENR0004'	'patch'	1.072150e+00	1.118984e+03	{'spike2-double' 'spike3-double'}	
	'DGNR_sc.mat'	'DGNR0005'	'patch'	9.409745e+02	1.375498e+03	{'spike1-double' 'spike2-double'}	
	'DGNR_sc.mat'	'DGNR0005'	'patch'	9.409745e+02	1.375498e+03	{'spike1-double' 'spike3-double'}	
	'DGNR_sc.mat'	'DGNR0005'	'patch'	9.168200e-01	1.414308e+03	{'spike2-double' 'spike3-double'}	
	'DHNR_sc.mat'	'DHNR0002'	'patch'	8.521000e-02	8.767829e+02	{'spike1-double' 'spike2-double'}	
	'DHNR_sc.mat'	'DHNR0007'	'patch'	8.132000e-02	8.372618e+01	{'spike1-double' 'spike2-double'}	
	'DHNR_sc.mat'	'DHNR0006'	'patch'	9.450186e+01	1.535355e+03	{'spike1-double' 'spike2-double'}	
	'DHNR_sc.mat'	'DHNR0006'	'patch'	1.216400e+01	1.535355e+03	{'spike1-double' 'spike3-double'}	
	'DHNR_sc.mat'	'DHNR0006'	'patch'	9.450186e+01	1.535387e+03	{'spike2-double' 'spike3-double'}	
	'DJNR_sc.mat'	'DJNR0005'	'patch'	4.098600e-01	1.908889e+03	{'ec-spike-p1-1' 'ec-spike-p1-2'}	
	'DJNR_sc.mat'	'DJNR0005'	'patch'	6.867948e+02	1.885877e+03	{'ec-spike-p1-1' 'ec-spike-p1-3'}	
	'DJNR_sc.mat'	'DJNR0005'	'patch2'	3.217580e+00	1.661128e+03	{'ic-spike-p2-1' 'ec-spike-p2-1'}	
	'HRNR_sc.mat'	'HRNR0000'	'patch'	2.581220e+00	1.187433e+03	{'ic-spike-p1-1' 'ec-spike-p1-1'}	
	'HRNR_sc.mat'	'HRNR0000'	'patch2'	1.235465e+01	1.282066e+03	{'ic-spike-p2-1' 'ec-spike-p2-1'}	
	'HVNR_sc.mat'	'HVNR0001'	'patch'	6.211180e+02	1.285840e+03	{'spike1-double' 'spike2-double'}	
	'ICNR_sc.mat'	'ICNR0002'	'patch'	1.226270e+00	1.833655e+03	{'ec-spike-p1-1' 'ic-spike-p1-1'}	
	'IFNR_sc.mat'	'IFNR0000'	'patch'	6.379480e+00	1.166898e+03	{'ec-spike-p1-1' 'ec-spike-p1-2'}	
	'IKNR_sc.mat'	'IKNR0000'	'patch'	1.917470e+00	4.532421e+02	{'ic-spike-p1-1' 'ec-spike-p1-1'}	
};

neurons(size(data, 1)) = ScNeuron();

for i=1:length(neurons)
  
  neurons (i) = ScNeuron(...
    'experiment_filename',  data{i, 1}, ...
    'file_tag',             data{i, 2}, ...
    'signal_tag',           data{i, 3}, ...
    'tmin',                 data{i, 4}, ...
    'tmax',                 data{i, 5}, ...
    'template_tag',         data{i, 6} ...
    );
  
end

end
