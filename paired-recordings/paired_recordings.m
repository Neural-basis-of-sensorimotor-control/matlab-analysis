data = {'BBNR_SSSA_sc.mat','BBNR0000'
'BBNR_SSSA_sc.mat','BBNR0001'
'BBNR_SSSA_sc.mat','BBNR0007'
'BCNR_SSSA_sc.mat','BCNR0037'
'BENR_SSSA_sc.mat','BENR0002'
'BGNR_SSSA_sc.mat','BGNR0001'
'BKNR_SSSA_sc.mat','BKNR0000'
'BMNR_SSSA_sc.mat','BMNR0000'
'BMNR_SSSA_sc.mat','BMNR0006'
'CANR_SSSA_sc.mat','CANR0005'
'CDNR_SSSA_sc.mat','CDNR0005'
'CENR_SSSA_sc.mat','CENR0001'
'CFNR_SSSA_sc.mat','CFNR0003'
'CNNR_SSSA_sc.mat','CNNR0009'
};

neurons = [];
for i=1:size(data,1)
  neurons = add_to_list(neurons, ...
    ScNeuron('experiment_filename', data{i,1}, 'file_tag', data{i,2}));
end
