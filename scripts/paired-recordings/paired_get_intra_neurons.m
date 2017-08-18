function neurons = paired_get_intra_neurons()

data = {
  'HRNR_sc.mat' 'HRNR0000' 'patch'  'ic-spike-p2-1'
  'HRNR_sc.mat' 'HRNR0000' 'patch2' 'ic-spike-p1-1'
  'HPNR_sc.mat' 'HPNR0003' 'patch'  'ic-spike-p2-1'
  'ILNR_sc.mat' 'ILNR0001' 'patch'  'ec-spike-p1-1'
  'IKNR_sc.mat' 'IKNR0000' 'patch'  'ec-spike-p1-1'
  'ICNR_sc.mat' 'ICNR0002' 'patch'  'ec-spike-p1-1'
  'IFNR_sc.mat' 'IFNR0000' 'patch'  'ec-spike-p1-1'
  'IFNR_sc.mat' 'IFNR0002' 'patch'  'ec-spike-p1-1'
  'DJNR_sc.mat' 'DJNR0005' 'patch'  'ic-spike-p2-1'
  'DJNR_sc.mat' 'DJNR0005' 'patch2' 'ec-spike-p2-1'
  'BPNR_sc.mat' 'BPNR0000' 'patch'  'ec-spike-p1-1'
  'BPNR_sc.mat' 'BPNR0001' 'patch'  'ec-spike-p1-1'
  };

neurons = [];

for i=1:size(data, 1)
  
  n = ScNeuron('experiment_filename', data{i, 1}, 'file_tag', data{i, 2}, ...
    'signal_tag', data{i, 3}, 'template_tag', data(i, 4));
  
  neurons = add_to_list(neurons, n);
  
end

end