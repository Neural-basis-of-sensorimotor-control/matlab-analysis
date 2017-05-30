function val = get_overlapping_spiketrains()

data = {
  'BKNR_SSSA_sc.mat', 'BKNR0000', 'patch',  '"spike"',                '"spike2"'
  'BMNR_SSSA_sc.mat', 'BMNR0000', 'patch',  '"spike"',                '"spike2dual"'
  'BMNR_SSSA_sc.mat', 'BMNR0006', 'patch',  '"spike"',                '"spike2"'
  'CANR_sc.mat',      'CANR0005', 'patch',  '"spike"',                '"spike2"'
  'CKNR_sc.mat',      'CKNR0001', 'patch',  'Spike0001-1',            'Spike0001-2'
  'DGNR_sc.mat',      'DGNR0005', 'patch',  'Spike0005-p1-1',         'Spike0005-p1-2'
  'DHNR_sc.mat',      'DHNR0002', 'patch',  'spike-patch1',           'spike2-patch'
  'DHNR_sc.mat',      'DHNR0002', 'patch2', 'spike-patch2',           'spike2-patch2'
  'DHNR_sc.mat',      'DHNR0003', 'patch2', 'smallspike2-patch2',     'spike-patch2'
  'DHNR_sc.mat',      'DHNR0007', 'patch2', 'spike-patch2',           'spike2-patch2'
  'DJNR_sc.mat',      'DJNR0007', 'patch',  'Spike0007-IC-firstcell', 'Spike0007-IC-p1'
  'BQNR_SSSA_sc.mat', 'BQNR0000', 'patch',  'Spike0000-1',            'Spike0000-2'
  'DBNR_sc.mat',      'DBNR0000', 'patch',  'Spike0000-1',            'Spike0000-2'
  'DBNR_sc.mat',      'DBNR0003', 'patch',  'Spike0003-1',            'Spike0003-2'
  'DENR_sc.mat',      'DENR0000', 'patch2', 'Spike0000-patch2',       'Spike0000-patch2-small'
  'DENR_sc.mat',      'DENR0004', 'patch',  'Spike0004-patch-IC',     'Spike0004-patch-EC'
  'BCNR_SSSA_sc.mat', 'BCNR0037', 'patch',  'spike',                  'dendritic spike'
  'BENR_SSSA_sc.mat', 'BENR0002', 'patch',  'spike',                  'spike2'
  'BGNR_SSSA_sc.mat', 'BGNR0001', 'patch',  'spike',                  'spike2'
  'BGNR_SSSA_sc.mat', 'BGNR0001', 'patch',  'spike2',                 'spike'
  'CANR_sc.mat',      'CANR0005', 'patch',  '"spike"',                '"spike2"'
  'CFNR_sc.mat',      'CFNR0003', 'patch',  '"spike"',                '"spike2"'
  'CNNR_sc.mat',      'CNNR0009', 'patch',  'Spike0009-Small',        'Spike0009-Large'
  'CENR_sc.mat',      'CENR0001', 'patch',  '"spike"',                '"spike2"'
  'CENR_sc.mat',      'CENR0001', 'patch',  '"spike2"',               '"spike"'
  'CANR_sc.mat',      'CANR0005', 'patch',  '"spike"',                '"spike2"'
  'CHNR_sc.mat',      'CHNR0003', 'patch',  '"spike1"',               '"spike2pyr"'
  'CHNR_sc.mat',      'CHNR0003', 'patch',  '"spike1"',               'spike2pyr'
  'CHNR_sc.mat',      'CHNR0003', 'patch',  'spike1',                 'spike2pyr'
  'BGNR_SSSA_sc.mat', 'BGNR0001', 'patch',  'spike',                  'spike2'
  'BGNR_SSSA_sc.mat', 'BGNR0003', 'patch',  'Spike0003-1',            'spike'
  'BKNR_SSSA_sc.mat', 'BKNR0002', 'patch',  'Spike0002',              '"spike"'
  'BKNR_SSSA_sc.mat', 'BKNR0004', 'patch',  'Spike0004',              '"spike"'
  'BKNR_SSSA_sc.mat', 'BKNR0007', 'patch',  'Spike0007',              '"spike"'
  'BNNR_SSSA_sc.mat', 'BNNR0007', 'patch',  'Spike0007',              '"spike"'
  'BNNR_SSSA_sc.mat', 'BNNR0008', 'patch',  'Spike0008-1',            '"spike"'
  'HLNR_sc.mat',      'HLNR0000', 'patch',  '"patch1spike1"',         '"patch1spike2"'
  'HVNR_sc.mat',      'HVNR0001', 'patch',  '"spike1patch1"',         '"spike2patch1"'
  'HVNR_sc.mat',      'HVNR0001', 'patch',  '"spike1patch1"',         '"spike2patch1"'
  };

val(size(data,1), 1) = ScNeuron();

for i=1:size(data, 1)
  
  val(i) = ScNeuron('experiment_filename', data{i,1}, ...
    'file_tag', data{i,2}, ...
    'signal_tag', data{i,3}, ...
    'template_tag', data(i,4:5));

end

end

% for i=1:len(overlapping_spiketrains)
%   x = overlapping_spiketrains(i);
%   n1 = x.neurons(1);
%   n2 = x.neurons(2);
%
%   fprintf('''%s'', ''%s'', ''%s'', ''%s'', ''%s''\n', ...
%   n1.experiment_filename, ...
%   n1.file_tag, ...
%   n1.signal_tag, ...
%   n1.tag, ...
%   n2.tag);
%
% end
%
%
%
