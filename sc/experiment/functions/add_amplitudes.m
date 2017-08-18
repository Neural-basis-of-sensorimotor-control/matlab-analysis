function add_amplitudes()

sc_dir = get_default_experiment_dir();

experiment_file = [sc_dir 'IDNR_sc.mat'];
file_tag = 'IDNR0001';
channel_str = 'patch';

signal = add_amplitudes_subfct(experiment_file, file_tag, channel_str);

signal.sc_save(true);

end

function signal = add_amplitudes_subfct(experiment_file, file_tag, channel_str, varargin)
tmin = 0; tmax = inf;

for i=1:2:length(varargin)
  prop = varargin{i};
  value = varargin{i+1};
  
  switch prop
    case 'tmin'
      tmin = value;
    case 'tmax'
      tmax = value;
    otherwise
      error('Unknown option: %s', varargin{i});
  end
end

if isempty(tmin), tmin = 0;   end
if isempty(tmax), tmax = inf; end

if nargin<3, channel_str = 'patch'; end

pattern_strs = {...
  '0.5 fa'
  '0.5 sa'
  '1.0 fa'
  '1.0 sa'
  '2.0 fa'
  '2.0 sa'
  'flat fa'
  'flat sa'
  };

stim_strs = {'V1', 'V2', 'V3', 'V4', 'V5', 'V6'};

dummy_sequence.tmin = tmin; dummy_sequence.tmax = tmax;

neuron = ScNeuron('experiment_filename', experiment_filename, ...
  'file_tag', file_tag, 'signal_tag', channel_str);
signal = sc_load_signal(neuron);
file = signal.parent;

file.sc_loadtimes();
textmark = file.textchannels.get('tag','TextMark');
textmark.sc_loadtimes();

for i=1:length(pattern_strs)
  pattern_str = pattern_strs{i};
  pattern = textmark.triggers.get('tag', pattern_str);
  pattern_times = pattern.gettimes(tmin, tmax);
  t_start = pattern_times(1); t_stop = pattern_times(1)+1;
  
  for j=1:length(stim_strs)
    stim_str = stim_strs{j};
    stim = file.stims.get('tag', stim_str).triggers.get(1);
    stim_times = stim.gettimes(tmin, tmax);
    stim_times = stim_times(stim_times > t_start & stim_times < t_stop);
    stim_inds = 1:length(stim_times);
    
    for k=1:length(stim_inds)
      str = sprintf('%s#%s#%d', pattern_str, stim_str, stim_inds(k));
      amplitudes = signal.amplitudes;
      
      if amplitudes.has('tag',str)
        %         if length(amplitudes.get('tag',str).N)>100
        %           amplitudes.remove('tag', str);
        %         else
        warning('Amplitude %s already in list', str);
        %        end
      else
        offset = stim_times(k) - t_start;
        amplitudes.add(ScAmplitude(dummy_sequence, signal, pattern, ...
          {'t1','v1','t2','v2'}, str, offset));
      end
    end
  end
end

[~, ind] = sort(amplitudes.values('tag'));
amplitudes.cell_list = amplitudes.cell_list(ind);

end