function neurons = paired_get_intra_neurons()

function remove_sweeps_around_stim
    error('Not implemented yet');
  end

  function subtract_other_patch_spike
    error('Not implemented yet');
  end

data = {
'BPNR_sc.mat'   'BPNR0001'  'patch'   -inf  inf   {'ec-spike-p1-1'}   'dendritspik?'  {} 
'DJNR_sc.mat'   'DJNR0005'  'patch2'  -inf  inf   {'ec-spike-p2-1'}   ''              {@remove_sweeps_around_stim}  %kasta bort EPSP:er +/- 1 ms från stim
'HPNR_sc.mat'   'HPNR0000'  'patch2'  -inf  inf   {'ec-spike-p1-1'}   ''              {}
'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ec-spike-p1-1'}   ''              {}
'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ec-spike-p1-1'}   ''              {}
'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ic-spike-p1-1'}   ''              {}
'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ic-spike-p1-1'}   ''              {@subtract_other_patch_spike} %pröva att subtrahera spike på patch1
'ICNR_sc.mat'   'ICNR0002'  'patch'   53    inf   {'ec-spike-p1-1'}   'BINGO'         {}  %median ~= mean -> separera olika IC svar
'IFNR_sc.mat'   'IFNR0000'  'patch'   -inf  inf   {'ec-spike-p1-1'}   ''              {}
'IKNR_sc.mat'   'IKNR0000'  'patch'   -inf  inf   {'ic-spike-p1-1'}   'BINGO'         {}
'ILNR_sc.mat'   'ILNR0001'  'patch'   -inf  inf   {'ic-spike-p1-1'}   'BINGO'         {}
};

neurons = [];
for i=1:size(data, 1)
  
  n = ScNeuron(...
    'experiment_filename',  data{i,1}, ...
    'file_tag',             data{i,2}, ...
    'signal_tag',           data{i,3}, ...
    'tmin',                 data{i,4}, ...
    'tmax',                 data{i,5}, ...
    'template_tag',         data{i,6}, ...
    'comment',              data{i,7}, ...
    'load_function',        data{i,8}, ...
    'tag',                  sprintf('IntraNeuron%03d', i));
  
  neurons = add_to_list(neurons, n);
  
end

end