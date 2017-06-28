function [response_1, spont_1, response_2, spont_2] = ...
  plot_double_cell_cross_corr(double_cell, varargin)

s.pretrigger = -.2;
s.posttrigger = .2;
s.kernelwidth = .001;
s.binwidth = .0001;

s.pretrigger2 = -.5;
s.posttrigger2 = 1.5;
s.kernelwidth2 = .001;
s.binwidth2 = .001;

s.min_latency = .0005;
s.max_latency = .4;

s = parse_inputs(s, varargin{:});

[pretrigger, posttrigger, kernelwidth, binwidth, pretrigger2, posttrigger2, ...
  kernelwidth2, binwidth2, min_latency, max_latency] = expand_inputs(s, 'pretrigger', 'posttrigger', ...
  'kernelwidth', 'binwidth', 'pretrigger2', 'posttrigger2', 'kernelwidth2', ...
  'binwidth2', 'min_latency', 'max_latency');

patterns = get_intra_patterns();
patterns = patterns(~startsWith(patterns, '1p electrode '));

signal = sc_load_signal(double_cell);

waveform1 = signal.waveforms.get('tag', double_cell.template_tag{1});
t1 = waveform1.gettimes(double_cell.tmin, double_cell.tmax);

waveform2 = signal.waveforms.get('tag', double_cell.template_tag{2});
t2 = waveform2.gettimes(double_cell.tmin, double_cell.tmax);

dim = [length(patterns), size(double_cell.time_sequences, 1)];

spont_1 = nan(dim);
response_1 = nan(dim);

spont_2 = nan(dim);
response_2 = nan(dim);

for j=1:size(double_cell.time_sequences, 1)
  
  incr_fig_indx();
  
  tmp_t1 = t1(t1 > double_cell.time_sequences(j,1) & t1 < double_cell.time_sequences(j,2));
  tmp_t2 = t2(t2 > double_cell.time_sequences(j,1) & t2 < double_cell.time_sequences(j,2));
  
  subplot(1, 2, 1);
  sc_kernelhist(tmp_t2, tmp_t1, pretrigger, posttrigger, kernelwidth, binwidth);
  title(sprintf('%s [%s] %d [%d]', waveform1.tag, waveform2.tag, ...
    numel(tmp_t1), numel(tmp_t2)));
  grid on
  
  subplot(1, 2, 2)
  sc_kernelhist(tmp_t1, tmp_t2, pretrigger, posttrigger, kernelwidth, binwidth);
  title(sprintf('%s [%s] %d [%d]', waveform2.tag, waveform1.tag, ...
    numel(tmp_t2), numel(tmp_t1)));
  grid on
  set(gcf, 'Name', [double_cell.file_tag ' ' double_cell.template_tag{1} ' ' double_cell.template_tag{2}]);
  
  %incr_fig_indx();
  
  
  for k=1:length(patterns)
    
    pattern_stim = signal.parent.gettriggers(0,inf).get('tag', patterns{k});
    stim_times = pattern_stim.gettimes(double_cell.time_sequences(j,1), ...
      double_cell.time_sequences(j,2));
    
    [response_1(k,j), spont_1(k,j)] = plot_conditional_pattern_response(stim_times, tmp_t1, tmp_t2, ...
      patterns{k}, waveform1.tag, waveform2.tag, varargin{:});
    
    [response_2(k,j), spont_2(k,j)] = plot_conditional_pattern_response(stim_times, tmp_t2, tmp_t1, ...
      patterns{k}, waveform2.tag, waveform1.tag, varargin{:});
    %
    %     sc_square_subplot(length(patterns), k)
    %     hold on
    %
    %     %sc_square_subplot(2*length(patterns), 2*k-1);
    %     sc_kernelhist(stim_times, tmp_t1, pretrigger2, posttrigger2, kernelwidth2, binwidth2);
    %     %     title(sprintf('%s [%s] %d %d', waveform1.tag, patterns{k}, ...
    %     %       numel(tmp_t1), numel(stim_times)));
    %     %     grid on
    %
    %
    %     %sc_square_subplot(2*length(patterns), 2*k);
    %     sc_kernelhist(stim_times, tmp_t2, pretrigger2, posttrigger2, kernelwidth2, binwidth2);
    %     %     title(sprintf('%s [%s] %d %d', waveform2.tag, patterns{k}, ...
    %     %       numel(tmp_t1), numel(stim_times)));
    %
    %     title(sprintf('%s [%d stims]', pattern_stim.tag, length(stim_times)))
    %     grid on
    %
  end
  
  %   legend(waveform1.tag, waveform2.tag);
  %   set(gcf, 'Name', [double_cell.file_tag 'patterns']);
  
end

end