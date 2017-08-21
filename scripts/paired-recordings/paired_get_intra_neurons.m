function neurons = paired_get_intra_neurons()

data = {
'BPNR_sc.mat'   'BPNR0001'  'patch'   -inf  inf   {'ec-spike-p1-1'}   'dendritspik?'  {} 
'DJNR_sc.mat'   'DJNR0005'  'patch'  -inf  inf    {'ec-spike-p2-1'}   ''              {@remove_sweeps_around_stim @remove_subsequent_triggers @(varargin) remove_sweeps_with_spike(varargin{:}, {'ec-spike-p1-1' 'ec-spike-p1-2' 'ec-spike-p1-3'})}  %kasta bort EPSP:er +/- 1 ms från stim
'DJNR_sc.mat'   'DJNR0005'  'patch'  -inf  inf    {'ic-spike-p2-1'}   ''              {@remove_sweeps_around_stim @remove_subsequent_triggers @(varargin) remove_sweeps_with_spike(varargin{:}, {'ec-spike-p1-1' 'ec-spike-p1-2' 'ec-spike-p1-3'})}  %kasta bort EPSP:er +/- 1 ms från stim
'HPNR_sc.mat'   'HPNR0000'  'patch2'  -inf  inf   {'ec-spike-p1-1'}   ''              {@remove_subsequent_triggers @remove_sweeps_around_stim}
'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ec-spike-p1-1'}   ''              {@(varargin) remove_sweeps_with_spike(varargin{:}, {'ec-spike-p2-1'})}
'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ec-spike-p1-1'}   ''              {@(varargin) remove_sweeps_with_spike(varargin{:}, {'ec-spike-p2-1'})}
'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ic-spike-p1-1'}   ''              {@(varargin) remove_sweeps_with_spike(varargin{:}, {'ic-spike-p2-1'})}
'HRNR_sc.mat'   'HRNR0000'  'patch2'  -inf  inf   {'ic-spike-p1-1'}   ''              {@subtract_other_patch_spike @(varargin) remove_sweeps_with_spike(varargin{:}, {'ic-spike-p1-1'})} %pröva att subtrahera spike på patch1
'ICNR_sc.mat'   'ICNR0002'  'patch'   53    inf   {'ec-spike-p1-1'}   'BINGO'         {@remove_subsequent_triggers}  %median ~= mean -> separera olika IC svar
'IFNR_sc.mat'   'IFNR0000'  'patch'   -inf  inf   {'ec-spike-p1-1'}   ''              {@(varargin) remove_sweeps_with_spike(varargin{:}, {'ec-spike-p1-2'})}
'IKNR_sc.mat'   'IKNR0000'  'patch'   -inf  inf   {'ic-spike-p1-1'}   'BINGO'         {@remove_subsequent_triggers}
'ILNR_sc.mat'   'ILNR0001'  'patch'   -inf  inf   {'ic-spike-p1-1'}   'BINGO'         {}
};

neurons = [];
for i=1:size(data, 1)
  
  n = ScNeuron(...
    'experiment_filename',  data{i,1}, ...
    'file_tag',             data{i,2}, ...
    'signal_tag',           data{i,3}, ...
    'tmin',                 data{i,4}, ...
    'tmax',                 data{i,5}, ...
    'template_tag',         data{i,6}, ...
    'comment',              data{i,7}, ...
    'ic_fcn',               data{i,8}, ...
    'tag',                  sprintf('IntraNeuron%03d', i));
  
  neurons = add_to_list(neurons, n);
  
end

end


function [v, trigger_times] = remove_sweeps_around_stim(v, trigger_times, ~, neuron, ...
  pretrigger, posttrigger)

stim_times = get_stim_times(neuron, {'V1', 'V2', 'V3', 'V4'});

ind = arrayfun(@(x) ...
  any( (cell2mat(stim_times') - x) < posttrigger & ...
  (cell2mat(stim_times') - x) > pretrigger), trigger_times);

trigger_times(ind) = [];

end


function [v, trigger_times] = subtract_other_patch_spike(v, trigger_times, signal, neuron, ...
  pretrigger, posttrigger)

filter_width = 500;

[sweeps, sweep_times] = sc_get_sweeps(v, 0, trigger_times, pretrigger, ...
  posttrigger, signal.dt);

[~, ind_zero] = min(abs(sweep_times));

v_mean = double(mean(sweeps, 2));
v_mean = v_mean - v_mean(ind_zero);

if is_double_patch(signal)
  
  neuron2 = neuron.clone();
  
  if strcmp(neuron.signal_tag, 'patch')
    neuron2.signal_tag = 'patch2';
  else
    neuron2.signal_tag = 'patch';
  end    
  
  neuron2.ic_fcn = {};
  sweeps2 = paired_get_sweeps(neuron2, pretrigger, posttrigger);
  
  v2_mean = double(mean(sweeps2, 2));  
  v2_mean = v2_mean - v2_mean(ind_zero);
  
  v2_mean = max(v_mean) / max(v2_mean) * v2_mean;
  
  trigger_pos = round(trigger_times / signal.dt);
  
  for i=1:length(trigger_pos)
    
    if get_debug_mode()
      fprintf('%d (%d)\n', i, length(trigger_pos));
    end
    
    pos    = trigger_pos(i) + (0: (filter_width-1));
    v(pos) = v(pos) - v2_mean(ind_zero + (0:(filter_width-1)));
    
  end
  
else
  error('No double patch')
end

end


function [v, trigger_times] = remove_sweeps_with_spike(v, trigger_times, signal, ~ , pretrigger, posttrigger, template_str)

ind = true(size(trigger_times));

for i=1:length(template_str)
  
  triggers = signal.parent.gettriggers(0, inf);
  spike = triggers.get('tag', template_str{i});
  spiketimes = spike.gettimes(0, inf);
  
  ind = ind & arrayfun(@(x) ~any(spiketimes - x > pretrigger & spiketimes - x < posttrigger), trigger_times);
  
end

trigger_times = trigger_times(ind);

fprintf('%d / %d\n', nnz(ind), length(ind));

end


function [v, trigger_times] = remove_subsequent_triggers(v, trigger_times, ~, ~ , ~, posttrigger)

trigger_times = trigger_times([diff(trigger_times)>posttrigger; true]);

end


