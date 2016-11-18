function neurons = get_intra_neurons(indx)
%Experiment file, Raw data file tag, Channel tag, time start, time stop, xPSP template

data ={
  'BJNR_sc.mat',    'BJNR0005',   'patch',  -inf, inf,  'EPSP5'
  'BKNR_sc.mat',    'BKNR0002',   'patch',  430,  1200,  'EPSP5'
  'BONR_sc.mat',    'BONR0006',   'patch',  -inf, inf,  'EPSP5'
  'BONR_sc.mat',    'BONR0009',   'patch',  -inf, inf,  'EPSP5'
  'BPNRtst_sc.mat', 'BPNR0000',   'patch',  -inf, inf,  'EPSP5'
  'BPNRtst_sc.mat', 'BPNR0001',   'patch',  -inf, inf,  'EPSP5'
  'CANR_sc.mat',    'CANR0001',   'patch',  -inf, inf,  'EPSP5'
  'CANR_sc.mat',    'CANR0008',   'patch',  -inf, inf,  'EPSP5'
  'CCNR_sc.mat',    'CCNR0000',   'patch',  235,  580,  'EPSP5'
  'DJNR_sc.mat',    'DJNR0005',   'patch',  900,  1800, 'EPSP5'
  'HPNR_sc.mat',    'HPNR0003',   'patch2', -inf, inf,  '?'
  'HRNR_sc.mat',    'HRNR0000',   'patch2', -inf, inf,  '?'
  'ICNR_sc.mat',    'ICNR0002',   'patch',  -inf, inf,  '?'
  'ICNR_sc.mat',    'ICNR0003',   'patch',  -inf, inf,  '?'
  'IFNR_sc.mat',    'IFNR0002',   'patch',  -inf, inf,  '?'
  'IFNR_sc.mat',    'IFNR0004',   'patch',  -inf, inf,  '?'
  'IHNR_sc.mat',    'IHNR0000',   'patch',  -inf, inf,  '?'
  'IHNR_sc.mat',    'IHNR0001',   'patch',  -inf, inf,  '?'
  'IKNR_sc.mat',    'IKNR0000',   'patch',  -inf, inf,  '?'
  'ILNR_sc.mat',    'ILNR0001',   'patch',  -inf, inf,  '?'
  'IDNR_sc.mat',    'IDNR0001',   'patch',  -inf, inf,  '?'
  };

for i=size(data,1):-1:1
  neurons(i).expr_file = data{i,1};
  neurons(i).file_str = data{i,2};
  neurons(i).signal_str = data{i,3};
  neurons(i).tmin = data{i,4};
  neurons(i).tmax = data{i,5};
  neurons(i).tag = sprintf('IntraNeuron%03d', i);
end

if nargin
  if isnumeric(indx)
    neurons = neurons(indx);
  elseif ischar(indx)
    neurons = get_items(neurons, 'file_str', indx);
  elseif iscell(indx)
    neurons = get_items(neurons, 'file_str', indx);
    
    if iscell(neurons)
      neurons = cell2mat(neurons);
    end
  end
end

end
