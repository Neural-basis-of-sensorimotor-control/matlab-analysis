pretrigger = -.2;
posttrigger = .2;
kernelwidth = .001;
binwidth = .0001;

pretrigger2 = -.5;
posttrigger2 = 1.5;
binwidth2 = .001;

patterns = get_intra_patterns();
patterns = patterns(~startsWith(patterns, '1p electrode'));

reset_fig_indx

for i=1:len(overlapping_spiketrains)
  fprintf('%d / %d\n', i, len(overlapping_spiketrains));
  
  tmp_pair = overlapping_spiketrains(i);
  
  t1 = tmp_pair.neurons(1).get_spiketimes();
  t2 = tmp_pair.neurons(2).get_spiketimes();
  
  for j=1:size(tmp_pair.time_sequences, 1)
    incr_fig_indx
    
    tmp_t1 = t1(t1 > tmp_pair.time_sequences(j,1) & t1 < tmp_pair.time_sequences(j,2));
    tmp_t2 = t2(t2 > tmp_pair.time_sequences(j,1) & t2 < tmp_pair.time_sequences(j,2));
    
    sc_square_subplot(2*size(tmp_pair.time_sequences, 1), 2*j-1);
    sc_kernelhist(tmp_t2, tmp_t1, pretrigger, posttrigger, binwidth);
    title(sprintf('t1 [t2] %d [%d]', numel(t1), numel(t2)));
    grid on
    
    sc_square_subplot(2*size(tmp_pair.time_sequences, 1), 2*j);
    sc_kernelhist(tmp_t1, tmp_t2, pretrigger, posttrigger, binwidth);
    title(sprintf('t2 [t1] %d [%d]', numel(t2), numel(t1)));
    grid on
    
    set(gcf, 'Name', [tmp_pair.neurons(1).file_tag 't1 t2']);
%     incr_fig_indx
%     
%     for k=1:length(patterns)
%       
%       times = ScSpikeTrainCluster.load_times(tmp_pair.raw_data_file, patterns(k));
%       
%       sc_square_subplot(2*length(patterns), 2*k-1);
%       sc_kernelhist(times, t1, pretrigger2, posttrigger2, binwidth2);
%       title(sprintf('t1 [%s] %d %d', patterns{k}, numel(t1), numel(times)));
%       grid on
%       
%       
%       sc_square_subplot(2*length(patterns), 2*k);
%       sc_kernelhist(times, t2, pretrigger2, posttrigger2, binwidth2);
%       title(sprintf('t2 [%s] %d %d', patterns{k}, numel(t2), numel(times)));
%       grid on
%       
%     end
    set(gcf, 'Name', [tmp_pair.neurons(1).file_tag 'patterns']);
  end
end



