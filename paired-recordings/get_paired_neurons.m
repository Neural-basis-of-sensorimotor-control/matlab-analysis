function neuron = get_paired_neurons()

data = {
  'BKNR_SSSA_sc.mat' 'BKNR0000'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  'BKNR_SSSA_sc.mat' 'BKNR0000'  'patch'   -inf inf {'spike1-double'	'spike3-double'}
  'BKNR_SSSA_sc.mat' 'BKNR0000'  'patch'   -inf inf {'spike2-double'	'spike3-double'}
  'BMNR_SSSA_sc.mat' 'BMNR0000'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  'BMNR_SSSA_sc.mat' 'BMNR0006'	'patch'   -inf inf {'spike1-double'	'spike2-double'}
  'CANR_sc.mat' 'CANR0005'	'patch'   -inf inf {'spike1-double'	'EPSP2'}
  'CKNR_sc.mat' 'CKNR0001'	'patch'   -inf inf {'spike1-double'	'spike2-double'}
  'DGNR_sc.mat' 'DGNR0005'	'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %'DGNR_sc.mat' 'DGNR0005'	'patch'   -inf inf {'spike1-double'	'spike3-double'}
  %'DGNR_sc.mat' 'DGNR0005'	'patch'   -inf inf {'spike2-double'	'spike3-double'}
  %'DHNR_sc.mat' 'DHNR0002'	'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %'DHNR_sc.mat'		'DHNR0004'Raw data not translated to.mat
  %'DHNR_sc.mat'		'DHNR0006'Raw data not translated to.mat
  %'DHNR_sc.mat'	'DHNR0007'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %'DBNR_sc.mat'	'DBNR0000'	'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %'DBNR_sc.mat'	'DBNR0001'	Raw data not translated to.mat
  %'DBNR_sc.mat'	'DBNR0003'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %'DENR_sc.mat' 'DENR0000'	'patch2'  -inf inf {'spike1-double'	'spike2-double'}
  %'DENR_sc.mat'	'DENR0004'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %'BENR_sc.mat'	'BENR0002'	Ngt fel med inläsning av datfilerna?
  %'CFNR_sc.mat'	'CFNR0003'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %'CNNR_sc.mat'	'CNNR0009'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %NR_CENR0	Ändra experimentnamn
  %'CHNR_sc.mat'	'CHNR0003'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  %'HVNR_sc.mat'	'HVNR0001'  'patch'   -inf inf {'spike1-double'	'spike2-double'}
  };

neuron = [];

for i=1:size(data,1)
  
  tmp_neuron = ScNeuron(...
    'experiment_filename', data{i,1}, ...
    'file_tag',            data{i,2}, ...
    'signal_tag',          data{i,3}, ...
    'tmin',                data{i,4}, ...
    'tmax',                data{i,5}, ...
    'template_tag',        data{i,6}, ...
    'tag',                 sprintf('Double %s', data{i,2}));
  
  neuron = add_to_list(neuron, tmp_neuron);
  
end

if nargin
  if isnumeric(indx)
    neuron = neuron(indx);
  elseif ischar(indx) || iscell(indx)
    neuron = get_items(neuron, 'file_tag', indx);
    
    if iscell(neuron)
      neuron = cell2mat(neuron);
    end
  end
end

end


% data = {...
%   'CANR_sc.mat', 'CANR0005', 'patch', ...
%   {'CANR0005_protonorm_spikes_001_double.dat', '"spike"'}, ...
%   {'CANR0005_protonorm_spikes_001_double.dat', '"spike2"'}
%
%   'DGNR_sc.mat', 'DGNR0005', 'patch', ...
%   {'DGNR0005_Spike0005-p1-1_Patch1.dat', 'Spike0005-p1-1'}, ...
%   {'DGNR0005_Spike0005-p1-2_Patch1.dat', 'Spike0005-p1-2'}
%
%   'DHNR_sc.mat', 'DHNR0002', 'patch', ...
%   {'DHNR0002_spike-patch1_Patch1.dat', 'spike-patch1'}, ...
%   {'DHNR0002_spike2-patch_Patch1.dat', 'spike2-patch'}
%
%   'DBNR_sc.mat', 'DBNR0000', 'patch', ...
%   {'DBNR0000_full_spikes_001.dat', 'Spike0000-1'}, ...
%   {'DBNR0000_full_spikes_001.dat', 'Spike0000-2'}
%
%   'DBNR_sc.mat', 'DBNR0003', 'patch', ...
%   {'DBNR0003_full_spikes_001.dat', 'Spike0003-1'}, ...
%   {'DBNR0003_full_spikes_001.dat', 'Spike0003-2'}
%
%   'DENR_sc.mat', 'DENR0000', 'patch2', ...
%   {'DENR0000_proto_spikes_001.dat', 'Spike0000-patch2'}, ...
%   {'DENR0000_proto_spikes_001.dat', 'Spike0003-patch2-small'}
%
%   'DENR_sc.mat', 'DENR0004', 'patch', ...
%   {'DENR0004_full_spikes_001.dat', 'Spike0004-patch-IC'}, ...
%   {'DENR0004_full_spikes_001.dat', 'Spike0004-patch-EC'}
%
%   'CFNR_sc.mat', 'CFNR0003', 'patch', ...
%   {'CFNR0003_!_spikes_001.dat', '"spike"'}, ...
%   {'CFNR0003_!_bothspikes_002.dat', '"spike2"'}
%
%   'CNNR_sc.mat', 'CNNR0009', 'patch', ...
%   {'CNNR0009_full_spikes_001.dat', 'Spike0009-Small'}, ...
%   {'CNNR0009_full_spikes_001.dat', 'Spike0009-Large'}
%
%   'CHNR_sc.mat', 'CHNR0003', 'patch', ...
%   {'CHNR0003_full_dualspike001.dat', '"spike1"'}, ...
%   {'CHNR0003_full_dualspike001.dat', '"spike2pyr"'}
%
%   'HVNR_sc.mat', 'HVNR0001', 'patch', ...
%   {'HVNR0001_full_spikes_001_patch1_1.dat', '"spike1patch1"'}, ...
%   {'HVNR0001_full_spikes_001_patch1_2.dat', '"spike2patch1"'}
%   };
%
% sc_dir = get_default_experiment_dir();
%
% for i=1:size(data, 1)
%
%   signal = sc_load_signal(data{i,1}, data{i,2}, data{i,3});
%   waveform = signal.waveforms;
%
%   for j=1:2
%
%     nonempty_waveform = waveform.list(arrayfun(@(x) ~isempty(x.imported_spikedata), waveform.list));
%
%     if any(arrayfun(@(x) ...
%         strcmp(x.imported_spikedata.raw_data_file, raw_data_file) & ...
%         strcmp(x.imported_spikedata.column_indx, column_indx), nonempty_waveform))
%       continue
%     end
%
%     k=0;
%     while ~k || waveform.has('tag', waveform_tag)
%      k=k+1;
%       waveform_tag = sprintf('spike%d-double', k);
%     end
%
%     tmp_waveform = ScWaveform(signal, waveform_tag, []);
%
%     raw_data_file = [sc_dir data{i, 3+j}{1}];
%     column_indx =  data{i, 3+j}{2};
%
%     tmp_waveform.imported_spikedata = ScSpikeData(...
%       'raw_data_file', raw_data_file, ...
%       'column_indx', column_indx);
%
%     waveform.add(tmp_waveform);
%   end
%
%   signal.sc_save(false);