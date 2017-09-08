function neurons = paired_get_experimental_ic_neurons()

data = {
  'BPNR_sc.mat     ' 'BPNR0001' 'patch' -inf inf {'dummy-spike-5'}
  'BPNR_sc.mat     ' 'BPNR0001' 'patch' -inf inf {'dummy-spike-6'}
  'BPNR_sc.mat     ' 'BPNR0001' 'patch' -inf inf {'dummy-spike-7'}
  'DJNR_sc.mat     ' 'DJNR0005' 'patch2' -inf inf {'dummy-spike-4'}
  'DJNR_sc.mat     ' 'DJNR0005' 'patch2' -inf inf {'dummy-spike-5'}
  'ICNR_sc.mat     ' 'ICNR0002' 'patch' -inf inf {'dummy-spike-4'}
  'ICNR_sc.mat     ' 'ICNR0002' 'patch' -inf inf {'dummy-spike-5'}
  'ICNR_sc.mat     ' 'ICNR0002' 'patch' -inf inf {'dummy-spike-6'}
  'ICNR_sc.mat     ' 'ICNR0002' 'patch' -inf inf {'dummy-spike-7'}
  'ICNR_sc.mat     ' 'ICNR0002' 'patch' -inf inf {'dummy-spike-8'}
  'ICNR_sc.mat     ' 'ICNR0002' 'patch' -inf inf {'dummy-spike-9'}
  'IKNR_sc.mat     ' 'IKNR0000' 'patch' -inf inf {'dummy-spike-4'}
  'IKNR_sc.mat     ' 'IKNR0000' 'patch' -inf inf {'dummy-spike-5'}
  'ILNR_sc.mat     ' 'ILNR0001' 'patch' -inf inf {'dummy-spike-4'}
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