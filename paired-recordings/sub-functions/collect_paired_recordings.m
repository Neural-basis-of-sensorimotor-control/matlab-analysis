function paired_neurons = collect_paired_recordings(same_patch_pipette, different_patch_pipette)

max_inactivity_time = 10;
min_nbr_of_spikes_per_sequence = 5;
min_time_span_per_sequence = 2;

paired_neurons = get_paired_candidates(same_patch_pipette, different_patch_pipette);

for i=1:length(paired_neurons)
  fprintf('%d out of %d |\n', i, length(paired_neurons));
  paired_neurons(i).time_sequences = get_sequence(paired_neurons(i), max_inactivity_time, ...
    min_nbr_of_spikes_per_sequence, min_time_span_per_sequence);
end

paired_neurons = get_items(paired_neurons, @(x) isempty(x.time_sequences), false);

reset_fig_indx();

plot_raster_paired_recordings(paired_neurons);

end

function sequence = get_sequence(paired_neuron, max_inactivity_time, ...
  min_nbr_of_spikes_per_sequence, min_time_span)

t1 = paired_neuron.neuron1.get_spiketimes();
t2 = paired_neuron.neuron2.get_spiketimes();

sequence = find_time_sequences(t1, t2, max_inactivity_time, ...
  min_nbr_of_spikes_per_sequence, min_time_span);

end


function paired_neurons = get_paired_candidates(same_patch_pipette, different_patch_pipette)

spike_data = get_raw_data();

paired_neurons = [];

for i=1:length(spike_data)
  fprintf('%d out of %d _\n', i, length(spike_data));
  
  neuron1 = spike_data(i);
  [~, tag_neuron1] = fileparts(neuron1.file_name);
  
  neuron2 = get_items(spike_data(i+1:end), 'file_tag', neuron1.file_tag);
  neuron2 = neuron2(neuron2 ~= neuron1);
  
  if same_patch_pipette
    tmp_neuron2 = get_items(neuron2, 'signal_tag', neuron1.signal_tag);
    
    for j=1:length(tmp_neuron2)
      [~, tag_neuron2] = fileparts(tmp_neuron2(j).file_name);

      tmp_pair = [];
      tmp_pair.neuron1 = neuron1;
      tmp_pair.neuron2 = get_item(tmp_neuron2, j);
      tmp_pair.time_sequences = [];
      tmp_pair.template_tag = {tag_neuron1 tag_neuron2};
      tmp_pair.file_tag = neuron1.file_tag;
      
      paired_neurons = add_to_list(paired_neurons, tmp_pair);
      
      paired_neurons = add_to_list(paired_neurons, tmp_pair);
    end
    
  end
  
  if different_patch_pipette
    tmp_neuron2 = get_items(neuron2, @(x) strcmp(x.signal_tag, neuron1.signal_tag), false);
    
    for j=1:length(tmp_neuron2)
      [~, tag_neuron2] = fileparts(tmp_neuron2(j).file_name);
      
      tmp_pair = [];
      tmp_pair.neuron1 = neuron1;
      tmp_pair.neuron2 = get_item(tmp_neuron2, j);
      tmp_pair.time_sequences = [];
      tmp_pair.template_tag = {tag_neuron1 tag_neuron2};
      tmp_pair.file_tag = neuron1.file_tag;
      
      paired_neurons = add_to_list(paired_neurons, tmp_pair);
    end
    
  end
end

end



function spike_data = get_raw_data()

top_dir = 'D:\temp\analyzed_data\';

folder_path_01 = 'Equipotentiality\Data\';

data_01 = {'CKNR0001_Spike0001-1_Patch1.dat',      'CKNR0001', 'patch'
  'CKNR0001_Spike0001-2_Patch1.dat',            'CKNR0001', 'patch2'
  'CSNR0000_Spike0000-p2_Patch2.dat',       'CSNR0000', 'patch2'
  'CSNR0000_Spike0000_Patch1.dat',          'CSNR0000', 'patch'
  'CSNR0001_Spike0001-p1_Patch1.dat',       'CSNR0001', 'patch'
  'CSNR0001_Spike0001-p2_Patch2.dat',       'CSNR0001', 'patch2'
  'CTNR0001_spike1p1_Patch1.dat',           'CSNR0001', 'patch'
  'CTNR0001_spike2p2_Patch2.dat',           'CSNR0001', 'patch2'
  'CTNR0002_spik1p1_Patch1.dat',            'CSNR0002', 'patch'
  'CTNR0002_spike3p2_Patch2.dat',           'CSNR0002', 'patch2'
  'CTNR0007_spike1p1_Patch1.dat',           'CSNR0007', 'patch'
  'CTNR0007_spike2p2_Patch2.dat',           'CSNR0007', 'patch2'
  'DFNR0001_Spike0001-patch1_Patch1.dat',   'DFNR0001', 'patch'
  'DFNR0001_Spike0001-patch2_Patch2.dat',   'DFNR0001', 'patch2'
  'DFNR0002_Spike0002-p1_Patch1.dat',       'DFNR0002', 'patch'
  'DFNR0002_Spike0002-p2_Patch2.dat',       'DFNR0002', 'patch2'
  'DGNR0001_Spike0001-p1_Patch1.dat',       'DGNR0001', 'patch'
  'DGNR0001_Spike0001-p2_Patch2.dat',       'DGNR0001', 'patch2'
  'DGNR0003_Spike0003-p1-IC_Patch1.dat',    'DGNR0003', 'patch'
  'DGNR0003_Spike0003-p2_Patch2.dat',       'DGNR0003', 'patch2'
  'DGNR0005_Spike0005-p1-1_Patch1.dat',     'DGNR0005', 'patch'
  'DGNR0005_Spike0005-p1-2_Patch1.dat',     'DGNR0005', 'patch'
  'DGNR0005_Spike0005-p2-1_Patch2.dat',     'DGNR0005', 'patch2'
  'DGNR0005_Spike0005-p2-2_Patch2.dat',     'DGNR0005', 'patch2'
  'DHNR0002_spike-patch1_Patch1.dat',       'DHNR0002', 'patch'
  'DHNR0002_spike-patch2_Patch2.dat',       'DHNR0002', 'patch2'
  'DHNR0002_spike2-patch2_Patch2.dat',      'DHNR0002', 'patch2'
  'DHNR0002_spike2-patch_Patch1.dat',       'DHNR0002', 'patch'
  'DHNR0003_smallspike2-patch2_Patch2.dat', 'DHNR0003', 'patch2'
  'DHNR0003_spike-patch2_Patch2.dat',       'DHNR0003', 'patch2'
  'DHNR0004_spike-patch2_Patch2.dat',       'DHNR0004', 'patch2'
  'DHNR0004_spike2-patch2_Patch2.dat',      'DHNR0004', 'patch2'
  'DHNR0005_spike-patch1_Patch1.dat',       'DHNR0005', 'patch'
  'DHNR0005_spike-patch2_Patch2.dat',       'DHNR0005', 'patch2'
  'DHNR0006_spike-patch1_Patch1.dat',       'DHNR0006', 'patch'
  'DHNR0006_spike-patch2_Patch2.dat',       'DHNR0006', 'patch2'
  'DHNR0006_spike2-patch1_Patch1.dat',      'DHNR0006', 'patch'
  'DHNR0007_spike-patch1_Patch1.dat',       'DHNR0007', 'patch'
  'DHNR0007_spike-patch2_Patch2.dat',       'DHNR0007', 'patch2'
  'DHNR0007_spike2-patch2_Patch2.dat',      'DHNR0007', 'patch2'
  'DINR0000_Spike0000-p1_Patch1.dat',       'DINR0000', 'patch'
  'DINR0000_Spike0000-p2_Patch2.dat',       'DINR0000', 'patch2'
  'DINR0001_Spike0001-p1_Patch1.dat' ,      'DINR0001', 'patch'
  'DINR0001_Spike0001-p2_Patch2.dat',       'DINR0001', 'patch2'
  'DINR0002_Spike0002-p1_Patch1.dat',       'DINR0002', 'patch'
  'DINR0002_Spike0002-p2_Patch2.dat',       'DINR0002', 'patch2'
  'DJNR0005_Spike0005-lateEC-p2_Patch2.dat','DJNR0005', 'patch2'
  'DJNR0005_Spike0005-lateIC-p1_Patch1.dat','DJNR0005', 'patch'
  'DJNR0006_Spike0006-EC-p2_Patch2.dat',    'DJNR0006', 'patch2'
  'DJNR0006_Spike0006-IC-p1_Patch1.dat',    'DJNR0006', 'patch'
  'DJNR0007_Spike0007-IC-firstcell_Patch2.dat', 'DJNR0007', 'patch2'
  'DJNR0007_Spike0007-IC-p1_Patch1.dat',    'DJNR0007', 'patch'
  'DJNR0008_Spike0008-1-p2_Patch2.dat',     'DJNR0008', 'patch2'
  'DJNR0008_Spike0008-p1_Patch1.dat',       'DJNR0008', 'patch'
  'DJNR0009_Spike0009-IC-p1_Patch1.dat',    'DJNR0009', 'patch'
  'DJNR0009_Spike0009-p2_Patch2.dat',       'DJNR0009', 'patch2'
  'DKNR0001_Spike0001-p1_Patch1.dat',       'DKNR0001', 'patch'
  'DKNR0001_Spike0001-p2_Patch2.dat',       'DKNR0001', 'patch2'
  'DKNR0004_Spike0004-p1_Patch1.dat',       'DKNR0004', 'patch'
  'DKNR0004_Spike0004-p2_Patch2.dat',       'DKNR0004', 'patch2' };

folder_path_02 = 'Multirecordings\CerebellumStimulering';
channel = 'patch';

data_02 = {
  'BQNR0000_full_spikes_001.dat', 'BQNR0000'
  'DBNR0000_full_spikes_001.dat' , 'DBNR0000'
  'DBNR0001_full_spikes_001.dat' , 'DBNR0001'
  'DBNR0003_full_spikes_001.dat' , 'DBNR0003'
  'DDNR0000_full_spikes_001.dat' , 'DDNR0000'
  'DENR0000_proto_spikes_001.dat', 'DENR0000'
  'DENR0002_full_spikes_001.dat' , 'DENR0002'
  'DENR0003_full_spikes_001.dat' , 'DENR0003'
  'DENR0004_full_spikes_001.dat' , 'DENR0004'
  'DENR0005_full_spikes_001.dat' , 'DENR0005'
  };

folder_path_03 = 'Multirecordings\ParietalCerebellum';

data_03 = {
  'DFNR0001_!_spikes_001.dat' ,                'DFNR0001'
  'DFNR0002_full_spikes_002.dat' ,             'DFNR0002'
  'DGNR0001_full_spikes_001.dat' ,             'DGNR0001'
  'DGNR0005_full_spikes_001.dat' ,             'DGNR0005'
  'DHNR0002_full_dualspikes_dualpatch001.dat', 'DHNR0002'
  'DHNR0003_full_dualspikes_patch2001.dat',    'DHNR0003'
  'DHNR0004_full_dualspikes_patch2001.dat',    'DHNR0004'
  'DHNR0005_full_spikes_dualpatch001.dat',     'DHNR0005'
  'DHNR0006_full_spikes_dualpatch001.dat',     'DHNR0006'
  'DHNR0007_full_spikes_dualpatch001.dat',     'DHNR0007'
  'DINR0000_full_spikes_001.dat',              'DINR0000'
  'DINR0001_full_spikes_001.dat',              'DINR0001'
  'DINR0002_full_spikes_001.dat',              'DINR0002'
  'DJNR0005_late_proto_spikes_001.dat',        'DJNR0005'
  'DJNR0006_full_spikes_001.dat',              'DJNR0006'
  'DJNR0007_first_proto_spikes_001.dat',       'DJNR0007'
  'DJNR0009_full_spikes_001.dat',              'DJNR0009'
  'DKNR0001_proto_spikes_001.dat',             'DKNR0001'
  'DKNR0004_full_spikes_001.dat ',             'DKNR0004'
  };

folder_path_04 = 'Multirecordings\ParietalCortex';

data_04 = {
  'CKNR0001_full_spikes_001.dat', 'CKNR0001'
  };

folder_path_05 = 'Multirecordings\SSSA';

data_05 = {
  'BBNR0000_protocol_spiketimes_doublecell_rec_doublepatch001.dat',        'BBNR0000'
  'BBNR0001_protocol_spiketimes_patch2_001.dat',                           'BBNR000'
  'BBNR0007_protocol_spiketimes_doublecell_rec_doublepatch001_noresp.dat', 'BBNR0007'
  'BCNR0037_protocol_spiketimes_doublecell_rec_inparallel002.dat',         'BCNR0037'
  'BENR0002_protocol_spiketimes_doublecell_rec_inparallel002.dat',         'BENR0002'
  'BGNR0001_protocol_spiketimes_doublecell_rec_inparallel002.dat',         'BGNR0001'
  'BKNR0000_proto healthy_spikes_001_double.dat',                          'BKNR0000'
  'BMNR0000_full_spikes_001_double.dat',                                   'BMNR0000'
  'BMNR0006_full_spikes_001_double.dat',                                   'BMNR0006'
  'CANR0005_proto_spikes_001.dat',                                         'CANR0005'
  'CFNR0003_!_spikes_001.dat',                                             'CFNR0003'
  'CNNR0009_full_spikes_001.dat',                                          'CNNR0009'
  'NR_CENR0001_full_spikes_twospikes_noresp001.dat',                       'CENR0001'};


folder_path_06 = 'Neocortex double neuron recordings';

data_06 = {
  'BKNR0000_proto healthy_spikes_001_double.dat', 'BKNR0000'
  'BMNR0000_full_spikes_001_double.dat',          'BMNR0000'
  'BMNR0006_full_spikes_001_double.dat',          'BMNR0006'
  'CANR0005_protonorm_spikes_001_double.dat',     'CANR0005'
  };

folder_path_07 = 'Rat neocortex SSSA\cerebellum-neocortex';

data_07 = {
  'BGNR0001_cer10p_dualspikes001.dat', 'BGNR0001'
  'BGNR0003_full_spikes_002.dat', 'BGNR0003'
  'BJNR0010_cer10p_full001.dat', 'BJNR0010'
  'BKNR0002_full_spikes_001.dat', 'BKNR0002'
  'BKNR0004_full_spikes_001.dat', 'BKNR0004'
  'BKNR0007_full_spikes_001-unclean.dat', 'BKNR0007'
  'BNNR0006_full_spikes_001.dat', 'BNNR0006'
  'BNNR0007_full_spikes_001.dat', 'BNNR0007'
  'BNNR0008_full_spikes_001.dat', 'BNNR0008'
  'BQNR0000_full_spikes_001.dat', 'BQNR0000'
  'DANR0000_full_spikes_001.dat', 'DANR0000'
  'DANR0003_full_spikes_001.dat', 'DANR0003'
  'DANR0004_LargeIC_spike_001.dat', 'DANR0004'
  'DBNR0000_full_spikes_001.dat', 'DBNR0000'
  'DBNR0001_full_spikes_001.dat', 'DBNR0001'
  'DBNR0003_full_spikes_001.dat', 'DBNR0003'
  'DBNR0004_full_spikes_001.dat', 'DBNR0004'
  'DCNR0000_full_spikes_001.dat', 'DCNR0000'
  'DCNR0001_full_spikes_001.dat', 'DCNR0001'
  'DCNR0002_full_spikes_002.dat', 'DCNR0002'
  'DCNR0003_full_spikes_001.dat', 'DCNR0003'
  'DDNR0000_full_spikes_001.dat', 'DDNR0000'
  'DDNR0001_full_spikes_001.dat', 'DDNR0001'
  'DENR0000_proto_spikes_001.dat', 'DENR0000'
  'DENR0002_full_spikes_001.dat', 'DENR0002'
  'DENR0003_full_spikes_001.dat', 'DENR0003'
  'DENR0004_full_spikes_001.dat', 'DENR0004'
  'DENR0005_full_spikes_001.dat', 'DENR0005'
  'DFNR0001_!_spikes_001.dat', 'DFNR0001'
  'DFNR0002_full_spikes_001.dat', 'DFNR0002'
  'DFNR0002_full_spikes_002.dat', 'DFNR0002'
  'DGNR0000_full_spikes_001.dat', 'DGNR0000'
  'DGNR0001_full_spikes_001.dat', 'DGNR0001'
  'DGNR0003_full_spikes_001.dat', 'DGNR0003'
  'DGNR0005_full_spikes_001.dat', 'DGNR0005'
  'DGNR0007_full_spikes_001.dat', 'DGNR0007'
  'DHNR0002_full_dualspikes_dualpatch001.dat', 'DHNR0002'
  'DHNR0003_full_dualspikes_patch2001.dat', 'DHNR0003'
  'DHNR0004_full_dualspikes_patch2001.dat', 'DHNR0004'
  'DHNR0005_full_spikes_dualpatch001.dat', 'DHNR0005'
  'DHNR0006_full_spikes_dualpatch001.dat', 'DHNR0006'
  'DHNR0007_full_spikes_dualpatch001.dat', 'DHNR0007'
  'DINR0000_full_spikes_001.dat', 'DINR0000'
  'DINR0001_full_spikes_001.dat', 'DINR0001'
  'DINR0002_full_spikes_001.dat', 'DINR0002'
  'DINR0003_full_spikes_001.dat', 'DINR0003'
  'DINR0004_full_spikes_001.dat', 'DINR0004'
  'DJNR0001_full_spikes_001.dat', 'DJNR0001'
  'DJNR0005_late_proto_spikes_001.dat', 'DJNR0005'
  'DJNR0006_full_spikes_001.dat', 'DJNR0006'
  'DJNR0007_first_proto_spikes_001.dat', 'DJNR0007'
  'DJNR0007_p2_first_cell_spikes_001.dat', 'DJNR0007'
  'DJNR0008_proto_spikes_001.dat', 'DJNR0008'
  'DJNR0009_full_spikes_001.dat', 'DJNR0009'
  'DKNR0000_full_spikes_001.dat', 'DKNR0000'
  'DKNR0001_proto_spikes_001.dat', 'DKNR0001'
  'DKNR0003_full_spikes_001.dat', 'DKNR0003'
  'DKNR0004_full_spikes_001.dat', 'DKNR0004'};


folder_path_08 = 'Rat neocortex SSSA\full spike-stimulation sets';

data_08 = {
  'BANR0323_protocol_spiketimes_001.dat', 'BANR0323'
  'BANR0325_protocol_spiketimes_001.dat', 'BANR0325'
  'BANR0326_protocol_spiketimes_001.dat', 'BANR0326'
  'BBNR0000_full_spikes_001.dat', 'BBNR0000'
  'BBNR0000_protocol_spiketimes_doublecell_rec_doublepatch001.dat', 'BBNR0000'
  'BBNR0000_protocol_spiketimes_patch1_001.dat', 'BBNR0000'
  'BBNR0001_protocol_spiketimes_patch2_001.dat', 'BBNR0001'
  'BBNR0002_protocol_spiketimes_patch2_001.dat', 'BBNR0002'
  'BBNR0004_protocol_spiketimes_patch2_001.dat', 'BBNR0004'
  'BBNR0007_protocol_spiketimes_doublecell_rec_doublepatch001_noresp.dat', 'BBNR0007'
  'BCNR0037_protocol_spiketimes_doublecell_rec_inparallel002.dat', 'BCNR0037'
  'BDNR0002_protocol_spiketimes_001.dat', 'BDNR0002'
  'BDNR0003_protocol_spiketimes_001_noresp_fewstims.dat', 'BDNR0003'
  'BDNR0004_protocol_spiketimes_002.dat', 'BDNR0004'
  'BDNR0005_protocol_spiketimes_001.dat', 'BDNR0005'
  'BDNR0006_protocol_spiketimes_002.dat', 'BDNR0006'
  'BENR0001_protocol_spiketimes_001.dat', 'BENR0001'
  'BENR0002_protocol_spiketimes_doublecell_rec_inparallel002.dat', 'BENR0002'
  'BENR0006_proto_spiketimes_001_fewstims.dat', 'BENR0006'
  'BENR0008_protocol_spiketimes_001.dat', 'BENR0008'
  'BENR0009_protocol_spiketimes_001.dat', 'BENR0009'
  'BENR0010_protocol_spiketimes_001.dat', 'BENR0010'
  'BFNR0004_protocol_spiketimes_001.dat', 'BFNR0004'
  'BFNR0005_protocol_spiketimes_001.dat', 'BFNR0005'
  'BGNR0001_protocol_spiketimes_doublecell_rec_inparallel002.dat', 'BGNR0001'
  'BGNR0003_protocol_spiketimes_001.dat', 'BGNR0003'
  'BHNR0001_protocol_spiketimes_001.dat', 'BHNR0001'
  'BHNR0002_proto_spikes_001.dat', 'BHNR0002'
  'BJNR0001_protocol_spiketimes_001.dat', 'BJNR0001'
  'BJNR0004_protocol_spiketimes_001_fewstims.dat', 'BJNR0004'
  'BJNR0009_protocol_spiketimes_001_fewstims.dat', 'BJNR0009'
  'BJNR0010_protocol_spiketimes_001.dat', 'BJNR0010'
  'BKNR0000_proto healthy_spikes_001_double.dat', 'BKNR0000'
  'BKNR0002_proto_spikes_001.dat', 'BKNR0002'
  'BKNR0004_full_spikes_001.dat', 'BKNR0004'
  'BKNR0007_all proto_spikes_001.dat', 'BKNR0007'
  'BMNR0000_full_spikes_001_double.dat', 'BMNR0000'
  'BMNR0006_full_spikes_001_double.dat', 'BMNR0006'
  'BNNR0007_full_spikes_001.dat', 'BNNR0007'
  'BNNR0008_full_spikes_001.dat', 'BNNR0008'
  'BONR0000_full_spikes_001.dat', 'BONR0000'
  'BONR0006_proto_spikes_001.dat', 'BONR0006'
  'BONR0009_proto_spikes_001.dat', 'BONR0009'
  'BPNR0000_all_spikes_001.dat', 'BPNR0000'
  'BPNR0001_full_spikes_001.dat', 'BPNR0001'
  'BPNR0011_full_spikes_001.dat', 'BPNR0011'
  'CANR0001_full_spikes_001.dat', 'CANR0001'
  'CANR0004_full_spikes_001.dat', 'CANR0004'
  'CANR0005_proto_spikes_001.dat', 'CANR0005'
  'CANR0006_full_spikes_001.dat', 'CANR0006'
  'CANR0010_full_spikes_001.dat', 'CANR0010'
  };

folder_path_09 = 'Rat neocortex SSSA\Parietal cortex';

data_09 = {
  'CJNR0000_full_spikes_001.dat', 'CJNR0000'
  'CJNR0001_!_spikes_001.dat', 'CJNR0001'
  'CJNR0003_!_spikes_001.dat', 'CJNR0003'
  'CJNR0004_!_spikes_001.dat', 'CJNR0004'
  'CJNR0006_full_spikes_001.dat', 'CJNR0006'
  'CKNR0001_full_spikes_001.dat', 'CKNR0001'
  'CKNR0002_full_spikes_001.dat', 'CKNR0002'
  'CKNR0003_full_spikes_001.dat', 'CKNR0003'
  'CKNR0005_full_spikes_001.dat', 'CKNR0005'
  'CKNR0006_!_spikes_001.dat', 'CKNR0006'
  'CKNR0007_full_spikes_001.dat', 'CKNR0007'
  'CKNR0008_full_spikes_001.dat', 'CKNR0008'
  'CLNR0000_full_spikes_001.dat', 'CLNR0000'
  'CLNR0001_full_spikes_001.dat', 'CLNR0001'
  'CLNR0002_full_spikes_quickanddirty.dat', 'CLNR0002'
  'CLNR0003_first_spikes_quickanddirty.dat', 'CLNR0003'
  'CLNR0004_full_spikes_001.dat', 'CLNR0004'
  'CLNR0005_!_spikes_001.dat', 'CLNR0005'
  'CMNR0002_full_spikes_001.dat', 'CMNR0002'
  'CONR0000_full_spikes_001.dat', 'CONR0000'
  'CONR0001_full_spikes_001.dat', 'CONR0001'
  'CONR0002_full_spikes_001.dat', 'CONR0002'
  'CONR0003_full_spikes_001.dat', 'CONR0003'
  'CONR0004_full_spikes_001.dat', 'CONR0004'
  'CONR0005_full_spikes_001.dat', 'CONR0005'
  'CONR0006_full_spikes_001.dat', 'CONR0006'
  'CONR0007_full_spikes_001.dat', 'CONR0007'
  'CONR0008_full_spikes_001.dat', 'CONR0008'
  'CPNR0000_full_spikes_001.dat', 'CPNR0000'
  'CPNR0001_full_spikes_001.dat', 'CPNR0001'
  'CPNR0003_full_spikes_001.dat', 'CPNR0003'
  'CPNR0004_full_spikes_001.dat', 'CPNR0004'
  'CPNR0005_full_spikes_001.dat', 'CPNR0005'
  'CPNR0006_merged_spikes_002.dat', 'CPNR0006'
  'CPNR0007_25rep_spikes_001.dat', 'CPNR0007'
  'CQNR0000_full_spikes_001.dat', 'CQNR0000'
  'CQNR0002_!_spikes_001.dat', 'CQNR0002'
  'CQNR0003_full_spikes_001.dat', 'CQNR0003'
  'CQNR0004_full_spikes_001.dat', 'CQNR0004'
  'CQNR0005_full_spikes_001.dat', 'CQNR0005'
  'CQNR0006_full_spikes_001.dat', 'CQNR0006'
  'CQNR0007_first_spikes_001.dat', 'CQNR0007'
  'CQNR0010_full_spikes_001.dat', 'CQNR0010'
  'CQNR0011_full_spikes_001.dat', 'CQNR0011'
  'CTNR0001_full_spikes_001.dat', 'CTNR0001'
  'CTNR0002_full_spikes_001.dat', 'CTNR0002'
  'CTNR0004_full_spikes_001.dat', 'CTNR0004'
  'CTNR0006_full_spikes_001.dat', 'CTNR0006'
  'CTNR0007_full_spikes_001.dat', 'CTNR0007'
  };

folder_path_10 = 'Stroke-photothrombotic\Information content analysis\dat files single cells\Prestroke';

data_10 = {
  'HBNR0000_full_spikes_001.dat',              'HBNR0000',  'patch2'
  'HCNR0002_full_spikes_002_patch1.dat',       'HCNR0002',  'patch'
  'HCNR0002_full_spikes_002_patch2.dat',       'HCNR0002',  'patch1'
  'HDNR0000_full_spikes_001.dat',              'HDNR0000',  'patch'
  'HENR0001_full_spikes_001_patch1.dat',       'HENR0001',  'patch'
  'HENR0001_full_spikes_001_patch2.dat',       'HENR0001',  'patch2'
  'HFNR0001_full_spikes_001_patch1.dat',       'HFNR0001',  'patch'
  'HFNR0001_full_spikes_001_patch2.dat',       'HFNR0001',  'patch2'
  'HINR0001_full_spikes_001_patch1.dat',       'HINR0001',  'patch'
  'HINR0001_full_spikes_001_patch2.dat',       'HINR0001',  'patch2'
  'HKNR0000_full_spikes_001_patch1.dat',       'HKNR0000',  'patch'
  'HKNR0000_full_spikes_001_patch2.dat',       'HKNR0000',  'patch2'
  'HLNR0000_full_spikes_001_patch1_1.dat',     'HLNR0000',  'patch'
  'HLNR0000_full_spikes_001_patch1_2.dat',     'HLNR0000',  'patch'
  'HLNR0000_full_spikes_001_patch2.dat',       'HLNR0000',  'patch2'
  'HPNR0000_full_spikes_001.dat',              'HPNR0000',  'patch2'
  'HSNR0002_full_spikes_001_endastpatch1.dat', 'HSNR0002',  'patch'
  'HVNR0001_full_spikes_001_patch1_1.dat',     'HVNR0001',  'patch'
  'HVNR0001_full_spikes_001_patch1_2.dat',     'HVNR0001',  'patch'
  'HVNR0001_full_spikes_001_patch2.dat',       'HVNR0001',  'patch2'
  'HXNR0001_full_spikes_001_patch1.dat',       'HXNR0001',  'patch'
  'HXNR0001_full_spikes_001_patch2.dat',       'HXNR0001',  'patch2'
  };

folder_path_11 = 'Stroke-photothrombotic\Information content analysis\dat files single cells\Prestroke\HVNRpatch1 not time modified';

data_11 = {
  'HVNR0001_full_spikes_001_patch1_1.dat', 'HVNR0001', 'patch'
  'HVNR0001_full_spikes_001_patch1_2.dat', 'HVNR0001', 'patch'
  };

spike_data = [];

spike_data = add_single_spike_file(spike_data, data_01, top_dir, folder_path_01);

spike_data = add_multiple_spike_file(spike_data, data_02, top_dir, folder_path_02, channel);
spike_data = add_multiple_spike_file(spike_data, data_03, top_dir, folder_path_03, channel);
spike_data = add_multiple_spike_file(spike_data, data_04, top_dir, folder_path_04, channel);
spike_data = add_multiple_spike_file(spike_data, data_05, top_dir, folder_path_05, channel);
spike_data = add_multiple_spike_file(spike_data, data_06, top_dir, folder_path_06, channel);
spike_data = add_multiple_spike_file(spike_data, data_07, top_dir, folder_path_07, channel);
spike_data = add_multiple_spike_file(spike_data, data_08, top_dir, folder_path_08, channel);
spike_data = add_multiple_spike_file(spike_data, data_09, top_dir, folder_path_09, channel);

spike_data = add_single_spike_file(spike_data, data_10, top_dir, folder_path_10);
spike_data = add_single_spike_file(spike_data, data_11, top_dir, folder_path_11);

end

function spike_data = add_single_spike_file(spike_data, data, top_dir, folder_path)

for i=1:size(data,1)
  spike_data = add_to_list(spike_data, ...
    ScSpikeData2(...
    'top_directory', top_dir, ...
    'folder_name', folder_path, ...
    'file_name', data{i,1}, ...
    'file_tag', data{i,2},...
    'signal_tag', data{i,3}, ...
    'read_column', 1));
end

end

function spike_data = add_multiple_spike_file(spike_data, data, top_dir, folder_path, channel)

for i=1:size(data,1)
  fid = fopen([top_dir filesep folder_path filesep data{i,1}]);
  headers = fgetl(fid);
  fclose(fid);
  
  headers = strsplit(headers, ',');
  
  ind = find(cellfun(@(x) ~isempty(strfind('pik', x)) || ~isempty(strfind('atch', x)), headers));
  
  for j=1:length(ind)
    spike_data = add_to_list(spike_data, ScSpikeData2(...
      'top_directory', top_dir, ...
      'folder_name', folder_path, ...
      'file_name', data{i,1}, ...
      'file_tag', data{i,2}, ...
      'signal_tag', channel, ...
      'read_column', ind(j)));
  end
end

end
