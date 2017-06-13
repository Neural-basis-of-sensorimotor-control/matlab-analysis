function neurons = get_paired_ic_neurons()

data = {
'HRNR_sc.mat' 'HRNR0000'  'patch' -inf inf {'ic-spike-p1-1'} ''
'HRNR_sc.mat' 'HRNR0000'  'patch' -inf inf {'ec-spike-p1-1'} ''
'HRNR_sc.mat' 'HRNR0000'  'patch2' -inf inf {'ic-spike-p2-1'} ''
'HPNR_sc.mat' 'HPNR0003'  'patch2' -inf inf {'ic-spike-p2-1'} ''
'ILNR_sc.mat' 'ILNR0001'  'patch' -inf inf  {'ic-spike-p1-1'} ''
'IKNR_sc.mat' 'IKNR0000'  'patch' -inf inf {'ic-spike-p1-1'} ''
'ICNR_sc.mat' 'ICNR0002'  'patch' -inf inf {'ic-spike-p1-1'} ''
'IFNR_sc.mat' 'IFNR0002'  'patch' -inf inf {'ic-spike-double-1'} '(2 olika, låg frekvens <- hittade bara en)'
'DJNR_sc.mat' 'DJNR0005'  'patch' -inf inf {'ic-spike-p1-1'} ''
'DJNR_sc.mat' 'DJNR0005'  'patch' -inf inf {'ic-spike-p2-1'} ''
'BPNR_sc.mat' 'BPNR0000'  'patch' -inf inf {'ic-spike-p1-1'} ''
'BPNR_sc.mat' 'BPNR0000'  'patch' -inf inf {'ec-spike-p1-1'} ''
'BPNR_sc.mat' 'BPNR0001'  'patch' -inf inf {'ic-spike-p1-1'} '(IPSP?)'
'BPNR_sc.mat' 'BPNR0001'  'patch' -inf inf {'ec-spike-p1-1'} '(IPSP?)'
};

neurons = [];

for i=1:size(data, 1)
  
  n = ScNeuron(...
    'experiment_filename', data{i,1}, ...
    'file_tag',            data{i,2}, ...
    'signal_tag',          data{i,3}, ...
    'tmin',                data{i,4}, ...
    'tmax',                data{i,5}, ...
    'template_tag',        data{i,6}, ...
    'tag',                 sprintf('IntraNeuron%03d', i));
  
  neurons = add_to_list(n);
  
end

end