function neurons = paired_get_intra_neurons()

data = {
%  'IKNR_sc.mat'   'IKNR0000'  'patch'   -inf  inf   {'ec-spike-p1-1'}   {'e-psp-p1-1'}  {'ic-spike-p1-1' 'remove-spike-1' 'remove-spike-2' 'remove-spike-3' 'remove-spike-4'}                   'stark EPSP'
%  'BPNR_sc.mat'   'BPNR0001'  'patch'   -inf  inf   {'ec-spike-p1-1'}   {}              {'ic-spike-p1-2' 'remove-spike-1' 'remove-spike-2' 'remove-spike-3' 'remove-spike-4'}                   'ingen EPSP, men illustrativ'
%  'ICNR_sc.mat'   'ICNR0002'  'patch'   53    inf   {'dummy-spike-8'}   {}              {'ic-spike-p1-1' 'ec-spike-p1-1'}  'bra exempel (testar nya templater II)'
  
  'DJNR_sc.mat'   'DJNR0005'  'patch2'  -inf  inf   {'dummy-spike-4'}   {'e-psp-p2-5'}              {'ic-spike-p2-1' 'remove-spike-1' 'remove-spike-2'}                   'svag EPSP (testar nya templater)'
  'DJNR_sc.mat'   'DJNR0005'  'patch2'  -inf  inf   {'ec-spike-p2-1'}   {'e-psp-p2-5'}              {'ic-spike-p2-1'  'remove-spike-1' 'remove-spike-2'}                   'svag EPSP'
  
  
  %'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ic-spike-p1-1'}   {}              {'ic-spike-p2-1'}                   'svag EPSP'
  %'ILNR_sc.mat'   'ILNR0001'  'patch'   -inf  inf   {'ec-spike-p1-1'}   {'e-psp-p1-1'}  {'ic-spike-p1-1'}                   'svag + otydlig EPSP'
  %'IFNR_sc.mat'   'IFNR0000'  'patch'   -inf  inf   {'ec-spike-p1-1'}   {}              {'ec-spike-p1-1'}                   'stark EPSP'
  %'HPNR_sc.mat'   'HPNR0000'  'patch2'  -inf  inf   {'ec-spike-p1-1'}   {}              {}                                  ''
  };

neurons(size(data, 1)) = ScNeuron();

for i=1:length(neurons)
  
  neurons (i) = ScNeuron(...
    'experiment_filename',  data{i, 1}, ...
    'file_tag',             data{i, 2}, ...
    'signal_tag',           data{i, 3}, ...
    'tmin',                 data{i, 4}, ...
    'tmax',                 data{i, 5}, ...
    'template_tag',         data{i, 6}, ...
    'xpsp_tag',             data{i, 7}, ...
    'artifact_tag',         data{i, 8}, ...
    'comment',              data{i, 9} ...
    );
  
end

end
