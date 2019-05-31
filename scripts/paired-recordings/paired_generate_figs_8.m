x = {
    'BKNR_SSSA_sc.mat', 'BKNR0000', 'patch', 'spike1-double'
    'BKNR_SSSA_sc.mat', 'BKNR0000', 'patch', 'spike2-double'
    
    'BMNR_SSSA_sc.mat', 'BMNR0000', 'patch', 'spike1-double'
    'BMNR_SSSA_sc.mat', 'BMNR0000', 'patch', 'spike2-double'
    
    'CENR_sc.mat', 'CENR0001', 'patch', 'spike1-double'
    'CENR_sc.mat', 'CENR0001', 'patch', 'spike2-double'
    
    'CFNR_sc.mat', 'CFNR0003', 'patch', 'spike1-double'
    'CFNR_sc.mat', 'CFNR0003', 'patch', 'spike2-double'
    'CFNR_sc.mat', 'CFNR0003', 'patch', 'spike-3'
    
    'CNNR_sc.mat', 'CNNR0009', 'patch', 'spike1-double'
    'CNNR_sc.mat', 'CNNR0009', 'patch', 'spike2-double'

    'DBNR_sc.mat', 'DBNR0003', 'patch', 'spike1-double'
    'DBNR_sc.mat', 'DBNR0003', 'patch', 'spike2-double'

    
    'DENR_sc.mat', 'DENR0004', 'patch', 'spike1-double'
    'DENR_sc.mat', 'DENR0004', 'patch', 'spike2-double'
    'DENR_sc.mat', 'DENR0004', 'patch', 'spike3-double'
    
    'DGNR_sc.mat', 'DGNR0005', 'patch', 'spike2-double'
    'DGNR_sc.mat', 'DGNR0005', 'patch', 'spike3-double'
    
    'DHNR_sc.mat', 'DHNR0002', 'patch', 'spike1-double'
    'DHNR_sc.mat', 'DHNR0002', 'patch', 'spike2-double'
    
    'DHNR_sc.mat', 'DHNR0006', 'patch', 'spike1-double'
    'DHNR_sc.mat', 'DHNR0006', 'patch', 'spike2-double'
    'DHNR_sc.mat', 'DHNR0006', 'patch', 'spike3-double'

    
    'DHNR_sc.mat', 'DHNR0007', 'patch', 'spike1-double'
    'DHNR_sc.mat', 'DHNR0007', 'patch', 'spike2-double'
    
    'DJNR_sc.mat', 'DJNR0005', 'patch2', 'ic-spike-p2-1'
    'DJNR_sc.mat', 'DJNR0005', 'patch2', 'ec-spike-p2-1'
    
    'HRNR_sc.mat', 'HRNR0000', 'patch', 'ic-spike-p1-1'
    'HRNR_sc.mat', 'HRNR0000', 'patch', 'ec-spike-p1-1'

    
    'HVNR_sc.mat', 'HVNR0001', 'patch', 'spike1-double'
    'HVNR_sc.mat', 'HVNR0001', 'patch', 'spike2-double'

    
    'ICNR_sc.mat', 'ICNR0002', 'patch', 'ec-spike-p1-1'
    'ICNR_sc.mat', 'ICNR0002', 'patch', 'ic-spike-p1-1'

    
    'IFNR_sc.mat', 'IFNR0000', 'patch', 'ec-spike-p1-1'
    'IFNR_sc.mat', 'IFNR0000', 'patch', 'ec-spike-p1-2'
    
    };

cell_data = struct;
exp_name   = '';
for i=1:size(x,1)
    [i size(x,1)]
    signal = sc_load_signal(ScNeuron('experiment_filename', x{i, 1}, ...
        'file_tag', x{i, 2}, 'signal_tag', x{i, 3}));
    waveform = signal.waveforms.get('tag', x{i, 4});
    if ~strcmp(exp_name, x{i, 1})
        [~, exp_name] = fileparts(x{i, 1});
        
        %Assumes only one Spike2 file per experiment
        stims = signal.parent.stims;
        stim_times = [];
        for j=1:stims.n
            stim_parent = stims.get(j);
            if stim_parent.istrigger
                stim_times  = [stim_times; stim_parent.gettimes(0, inf)];
            else
                for k=1:stim_parent.triggers.n
                    stim = stim_parent.triggers.get(k);
                    stim_times = [stim_times; stim.gettimes(0, inf)];
                end
            end
        end
        stim_times = sort(stim_times);
        txt2 = '';
        for j=1:length(stim_times)
            txt2 = [txt2 num2str(stim_times(j)) ';'];
        end
        if ~isempty(txt2)
            txt2 = txt2(1:end-1);
        end
        cell_data.experiment.(exp_name).stimtimes.Text = txt;
    end
    neuron_name = x{i, 4};
    neuron_name = strrep(neuron_name, '-', '_');
    spiketimes = waveform.gettimes(0, inf);
    txt = '';
    for j=1:(length(spiketimes))
        txt = [txt num2str(spiketimes(j)) ';'];
    end
    if ~isempty(txt)
        txt = txt(1:end-1);
    end
    cell_data.experiment.(exp_name).spiketimes.(neuron_name).Text = txt;
end

struct2xml(cell_data, 'spike-times.xml')