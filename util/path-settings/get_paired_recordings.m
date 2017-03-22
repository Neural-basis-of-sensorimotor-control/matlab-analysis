folder_path = 'D:\temp\analyzed_data\Equipotentiality\Data\';

data = {'CKNR0001_Spike0001-1_Patch1',      'CKNR0001', 'patch'
  'CKNR0001_Spike0001-2_Patch1',            'CKNR0001', 'patch2'
  'CSNR0000_Spike0000-p2_Patch2',       'CSNR0000', 'patch2'
  'CSNR0000_Spike0000_Patch1',          'CSNR0000', 'patch'
  'CSNR0001_Spike0001-p1_Patch1',       'CSNR0001', 'patch'
  'CSNR0001_Spike0001-p2_Patch2',       'CSNR0001', 'patch2'
  'CTNR0001_spike1p1_Patch1',           'CSNR0001', 'patch'
  'CTNR0001_spike2p2_Patch2',           'CSNR0001', 'patch2'
  'CTNR0002_spik1p1_Patch1',            'CSNR0002', 'patch'
  'CTNR0002_spike3p2_Patch2',           'CSNR0002', 'patch2'
  'CTNR0007_spike1p1_Patch1',           'CSNR0007', 'patch'
  'CTNR0007_spike2p2_Patch2',           'CSNR0007', 'patch2'
  'DFNR0001_Spike0001-patch1_Patch1',   'DFNR0001', 'patch'
  'DFNR0001_Spike0001-patch2_Patch2',   'DFNR0001', 'patch2'
  'DFNR0002_Spike0002-p1_Patch1',       'DFNR0002', 'patch'
  'DFNR0002_Spike0002-p2_Patch2',       'DFNR0002', 'patch2'
  'DGNR0001_Spike0001-p1_Patch1',       'DGNR0001', 'patch'
  'DGNR0001_Spike0001-p2_Patch2',       'DGNR0001', 'patch2'
  'DGNR0003_Spike0003-p1-IC_Patch1',    'DGNR0003', 'patch'
  'DGNR0003_Spike0003-p2_Patch2',       'DGNR0003', 'patch2'
  'DGNR0005_Spike0005-p1-1_Patch1',     'DGNR0005', 'patch'
  'DGNR0005_Spike0005-p1-2_Patch1',     'DGNR0005', 'patch'
  'DGNR0005_Spike0005-p2-1_Patch2',     'DGNR0005', 'patch2'
  'DGNR0005_Spike0005-p2-2_Patch2',     'DGNR0005', 'patch2'
  'DHNR0002_spike-patch1_Patch1',       'DHNR0002', 'patch'
  'DHNR0002_spike-patch2_Patch2',       'DHNR0002', 'patch2'
  'DHNR0002_spike2-patch2_Patch2',      'DHNR0002', 'patch2'
  'DHNR0002_spike2-patch_Patch1',       'DHNR0002', 'patch'
  'DHNR0003_smallspike2-patch2_Patch2', 'DHNR0003', 'patch2'
  'DHNR0003_spike-patch2_Patch2',       'DHNR0003', 'patch2'
  'DHNR0004_spike-patch2_Patch2',       'DHNR0004', 'patch2'
  'DHNR0004_spike2-patch2_Patch2',      'DHNR0004', 'patch2'
  'DHNR0005_spike-patch1_Patch1',       'DHNR0005', 'patch'
  'DHNR0005_spike-patch2_Patch2',       'DHNR0005', 'patch2'
  'DHNR0006_spike-patch1_Patch1',       'DHNR0006', 'patch'
  'DHNR0006_spike-patch2_Patch2',       'DHNR0006', 'patch2'
  'DHNR0006_spike2-patch1_Patch1',      'DHNR0006', 'patch'
  'DHNR0007_spike-patch1_Patch1',       'DHNR0007', 'patch'
  'DHNR0007_spike-patch2_Patch2',       'DHNR0007', 'patch2'
  'DHNR0007_spike2-patch2_Patch2',      'DHNR0007', 'patch2'
  'DINR0000_Spike0000-p1_Patch1',       'DINR0000', 'patch'
  'DINR0000_Spike0000-p2_Patch2',       'DINR0000', 'patch2'
  'DINR0001_Spike0001-p1_Patch1' ,      'DINR0001', 'patch'
  'DINR0001_Spike0001-p2_Patch2',       'DINR0001', 'patch2'
  'DINR0002_Spike0002-p1_Patch1',       'DINR0002', 'patch'
  'DINR0002_Spike0002-p2_Patch2',       'DINR0002', 'patch2'
  'DJNR0005_Spike0005-lateEC-p2_Patch2','DJNR0005', 'patch2'
  'DJNR0005_Spike0005-lateIC-p1_Patch1','DJNR0005', 'patch'
  'DJNR0006_Spike0006-EC-p2_Patch2',    'DJNR0006', 'patch2'
  'DJNR0006_Spike0006-IC-p1_Patch1',    'DJNR0006', 'patch'
  'DJNR0007_Spike0007-IC-firstcell_Patch2', 'DJNR0007', 'patch2'
  'DJNR0007_Spike0007-IC-p1_Patch1',    'DJNR0007', 'patch'
  'DJNR0008_Spike0008-1-p2_Patch2',     'DJNR0008', 'patch2'
  'DJNR0008_Spike0008-p1_Patch1',       'DJNR0008', 'patch'
  'DJNR0009_Spike0009-IC-p1_Patch1',    'DJNR0009', 'patch'
  'DJNR0009_Spike0009-p2_Patch2',       'DJNR0009', 'patch2'
  'DKNR0001_Spike0001-p1_Patch1',       'DKNR0001', 'patch'
  'DKNR0001_Spike0001-p2_Patch2',       'DKNR0001', 'patch2'
  'DKNR0004_Spike0004-p1_Patch1',       'DKNR0004', 'patch'
  'DKNR0004_Spike0004-p2_Patch2',       'DKNR0004', 'patch2' };

spike_data(size(data,2)) = ScSpikeData;

for i=1:size(data,1)
  spike_data(i) = ScSpikeData('folder_path', folder_path, ...
    'file_name', data{i,1}, ...
    'file_ext', 'dat', ...
    'file_tag', data{i,2},...
    'signal_tag', data{i,3}, ...
    'read_column', 1);
end

BGNR0001_cer10p_dualspikes001.dat        
BGNR0003_full_spikes_002.dat             
BJNR0010_cer10p_full001.dat              
BKNR0002_full_spikes_001.dat             
BKNR0004_full_spikes_001.dat             
BKNR0007_full_spikes_001-unclean.dat     
BNNR0006_full_spikes_001.dat             
BNNR0007_full_spikes_001.dat             
BNNR0008_full_spikes_001.dat             
BQNR0000_full_spikes_001.dat             
DANR0000_full_spikes_001.dat             
DANR0003_full_spikes_001.dat             
DANR0004_LargeIC_spike_001.dat           
DBNR0000_full_spikes_001.dat             
DBNR0001_full_spikes_001.dat             
DBNR0003_full_spikes_001.dat             
DBNR0004_full_spikes_001.dat             
DCNR0000_full_spikes_001.dat             
DCNR0001_full_spikes_001.dat             
DCNR0002_full_spikes_002.dat             
DCNR0003_full_spikes_001.dat             
DDNR0000_full_spikes_001.dat             
DDNR0001_full_spikes_001.dat             
DENR0000_proto_spikes_001.dat            
DENR0002_full_spikes_001.dat             
DENR0003_full_spikes_001.dat             
DENR0004_full_spikes_001.dat             
DENR0005_full_spikes_001.dat             
DFNR0001_!_spikes_001.dat                
DFNR0002_full_spikes_001.dat             
DFNR0002_full_spikes_002.dat             
DGNR0000_full_spikes_001.dat             
DGNR0001_full_spikes_001.dat             
DGNR0003_full_spikes_001.dat             
DGNR0005_full_spikes_001.dat             
DGNR0007_full_spikes_001.dat             
DHNR0002_full_dualspikes_dualpatch001.dat
DHNR0003_full_dualspikes_patch2001.dat   
DHNR0004_full_dualspikes_patch2001.dat   
DHNR0005_full_spikes_dualpatch001.dat    
DHNR0006_full_spikes_dualpatch001.dat    
DHNR0007_full_spikes_dualpatch001.dat    
DINR0000_full_spikes_001.dat             
DINR0001_full_spikes_001.dat             
DINR0002_full_spikes_001.dat             
DINR0003_full_spikes_001.dat             
DINR0004_full_spikes_001.dat             
DJNR0001_full_spikes_001.dat             
DJNR0005_late_proto_spikes_001.dat       
DJNR0006_full_spikes_001.dat             
DJNR0007_first_proto_spikes_001.dat      
DJNR0007_p2_first_cell_spikes_001.dat    
DJNR0008_proto_spikes_001.dat            
DJNR0009_full_spikes_001.dat             
DKNR0000_full_spikes_001.dat             
DKNR0001_proto_spikes_001.dat            
DKNR0003_full_spikes_001.dat             
DKNR0004_full_spikes_001.dat             