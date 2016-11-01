function neurons = get_intra_neurons(indx)

data ={
  'IHNR_sc.mat',    'IHNR0000',   'patch',  -inf, inf
  'HPNR_sc.mat',    'HPNR0003',   'patch2', -inf, inf
  'IKNR_sc.mat',    'IKNR0000',   'patch',  -inf, inf
  'IFNR_sc.mat',    'IFNR0004',   'patch',  -inf, inf
  'ILNR_sc.mat',    'ILNR0001',   'patch',  -inf, inf
  'IFNR_sc.mat',    'IFNR0002',   'patch',  -inf, inf
  'IHNR_sc.mat',    'IHNR0001',   'patch',  -inf, inf
  'ICNR_sc.mat',    'ICNR0003',   'patch',  -inf, inf
  'ICNR_sc.mat',    'ICNR0002',   'patch',  -inf, inf
  'HRNR_sc.mat',    'HRNR0000',   'patch2', -inf, inf
  'BENR_sc.mat',    'BENR0005',   'patch',  -inf, inf
  'BJNR_sc.mat',    'BJNR0005',   'patch',  -inf, inf
  'BONR_sc.mat',    'BONR0009',   'patch',  -inf, inf
  'BONR_sc.mat',    'BONR0006',   'patch',  -inf, inf
  'CCNR_sc.mat',    'CCNR0000',   'patch',  235, 580
  'CANR_sc.mat',    'CANR0008',   'patch',  -inf, inf
  'CANR_sc.mat',    'CANR0001',   'patch',  -inf, inf
  'BPNR_sc.mat',    'BPNR0000',   'patch',  -inf, inf
  'BPNR_sc.mat',    'BPNR0001',   'patch',  -inf, inf
  'BNNR_sc.mat',    'BNNR0007',   'patch',  -inf, inf
  'BKNR_sc.mat',    'BKNR0002',   'patch',  -inf, inf
  'BKNR_sc.mat',    'BKNR0000',   'patch',  -inf, inf
  'BHNR_sc.mat',    'BHNR0002',   'patch',  -inf, inf
  'BGNR_sc.mat',    'BGNR0000',   'patch',  -inf, inf
  'DJNR_sc.mat',    'DJNR0005',   'patch',  900,  1800
  'BPNRtst_sc.mat', 'BPNR0000',   'patch',  -inf, inf
  'BPNRtst_sc.mat', 'BPNR0001',   'patch',  -inf, inf};

for i=size(data,1):-1:1
  neurons(i).expr_file = data{i,1};
  neurons(i).file_str = data{i,2};
  neurons(i).signal_str = data{i,3};
  neurons(i).tmin = data{i,4};
  neurons(i).tmax = data{i,5};
  neurons(i).tag = sprintf('IntraNeuron%03d', i);
end

if nargin
  neurons = neurons(indx);
end

end
