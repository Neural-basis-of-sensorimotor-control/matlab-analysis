if true
  clc
  clear
  sc_clf_all('reset')
  reset_fig_indx();
  
  max_idle_time = 10;
  pretrigger = -1;
  posttrigger = 1.5;
  kernelwidth = 5e-3;
  binwidth = 1e-4;
  scaling_dim = 2;
  tmin = 0;
  tmax = 1;
  
  
  %% Scan for paired recordings
  
  % Get all prospective measurement files
  
  file = get_file_recursive('D:\temp\analyzed_data\', '*.dat');
  
  % Extract neurons from files
  
  neuron = get_neuron_from_dat(file);
  
  % Collect spiketrains with simultaneous activity
  double_neuron(100, 1) = ScSpikeTrainCluster();
  counter = 0;
  
  for i=1:(length(neuron)-1)
    fprintf('%d (%d)\n', i, length(neuron));
    
    for j=i+1:length(neuron)
      
      [is_matching, common_sequence] = spiketrain_matches(double_neuron(1:counter), ...
        neuron(i), neuron(j), true, false, max_idle_time);
      
      if is_matching
        
        counter = counter + 1;
        double_neuron(counter) = ScSpikeTrainCluster('neurons', ...
          [neuron(i); neuron(j)], 'time_sequences', common_sequence, ...
          'tag', neuron(i).file_tag);
        
      end
    end
  end
  
  double_neuron = double_neuron(1:counter);
  
  
  %Remove known duplicates
  tmp_cmp_fcn = @(x, i, j) strcmp(x.neurons(i).raw_data_file, 'D:\temp\analyzed_data\Rat neocortex SSSA\cerebellum-neocortex\BKNR0002_full_spikes_001.dat') ...
    && strcmp(x.neurons(i).tag, 'Spike0002') && ...
    strcmp(x.neurons(j).raw_data_file, 'D:\temp\analyzed_data\Rat neocortex SSSA\full spike-stimulation sets\BKNR0002_proto_spikes_001.dat') ...
    && strcmp(x.neurons(j).tag, '"spike"');
  
  rm_indx = arrayfun(@(x) tmp_cmp_fcn(x, 1, 2) || tmp_cmp_fcn(x, 2, 1), double_neuron);
  
  double_neuron(rm_indx) = [];
  
  tmp_cmp_fcn = @(x, i, j) strcmp(x.neurons(i).raw_data_file, 'D:\temp\analyzed_data\Rat neocortex SSSA\cerebellum-neocortex\BKNR0004_full_spikes_001.dat') ...
    && strcmp(x.neurons(i).tag, 'Spike0004') && ...
    strcmp(x.neurons(j).raw_data_file, 'D:\temp\analyzed_data\Rat neocortex SSSA\full spike-stimulation sets\BKNR0004_full_spikes_001.dat') ...
    && strcmp(x.neurons(j).tag, '"spike"');
  
  rm_indx = arrayfun(@(x) tmp_cmp_fcn(x, 1, 2) || tmp_cmp_fcn(x, 2, 1), double_neuron);
  
  double_neuron(rm_indx) = [];
  
  save paired_1
  
  % Summon all stim times from all time segments for each paired recording
  
  pattern = get_intra_patterns();
  pattern = pattern(~startsWith(pattern, '1p electrode'));
  
  to_be_deleted = false(size(double_neuron));
  
  for i=1:length(double_neuron)
    fprintf('%d (%d)^1\n', i, length(double_neuron));
    
    tmp_double_neuron = double_neuron(i);
    
    for j=1:2
      
      for k=1:length(pattern)
        
        tmp_pattern = pattern{k};
        
        tmp_pattern_time = ScSpikeTrainCluster.load_times(tmp_double_neuron.neurons(j).raw_data_file, ...
          tmp_pattern);
        
        if length(tmp_pattern_time)<10
          to_be_deleted(i) = true;
          break
        end
      end
    end
  end
  
  double_neuron(to_be_deleted) = [];
  
  
  y_lower = 0;
  y_upper = 4;
  
  for i=1:length(double_neuron)
    fprintf('%d (%d)*\n', i, length(double_neuron));
    
    tmp_double_neuron = double_neuron(i);
    set_userdata(tmp_double_neuron, []);
    
    t1 = tmp_double_neuron.neurons(1).get_spiketimes();
    t2 = tmp_double_neuron.neurons(2).get_spiketimes();
    
    t1 = extract_within_sequence(t1, tmp_double_neuron.time_sequences);
    t2 = extract_within_sequence(t2, tmp_double_neuron.time_sequences);
    
    set_userdata(tmp_double_neuron.neurons(1), []);
    set_userdata(tmp_double_neuron.neurons(1), 'spiketime', t1);
    set_userdata(tmp_double_neuron.neurons(2), []);
    set_userdata(tmp_double_neuron.neurons(2), 'spiketime', t2);
    
    pattern_time = cell(size(pattern));
    
    for j=1:length(pattern)
      
      tmp_pattern = pattern{j};
      
      tmp_pattern_time = ScSpikeTrainCluster.load_times(tmp_double_neuron.neurons(1).raw_data_file, ...
        tmp_pattern);
      tmp_pattern_time = extract_within_sequence(tmp_pattern_time, ...
        bsxfun(@plus, tmp_double_neuron.time_sequences, -[pretrigger posttrigger]));
      
      pattern_time(j) = {tmp_pattern_time};
    end
    
    tmp_double_neuron.userdata.pattern_time = pattern_time;
    
    incr_fig_indx();
    clf('reset')
    hold on
    
    for j=1:size(tmp_double_neuron.time_sequences,1)
      
      xleft = tmp_double_neuron.time_sequences(j, 1);
      xright = tmp_double_neuron.time_sequences(j, 2);
      patch([xleft xleft xright xright], [y_lower y_upper y_upper y_lower], .95*[1 1 1])
      
    end
    
    plot(t2, ones(size(t2)), '+');
    plot(t1, 2*ones(size(t1)), '+');
    
    for j=1:length(pattern_time)
      tmp_pattern_time = pattern_time{j};
      plot(tmp_pattern_time, 3*ones(size(tmp_pattern_time)), '+');
    end
    
    title(tmp_double_neuron.neurons(1).file_tag);
    
    set(gca, 'YTick', 1:3, 'YTickLabel', ...
      {tmp_double_neuron.neurons(2).tag, tmp_double_neuron.neurons(1).tag, 'Pattern onset'});
  end
  
  save paired_2
  
  % For all recordings: Perform convoluted estimation
  
  for i=1:length(double_neuron)
    fprintf('%d (%d)**\n', i, length(double_neuron));
    
    tmp_double_neuron = double_neuron(i);
    
    tag1 = tmp_double_neuron.neurons(1).tag;
    tag2 = tmp_double_neuron.neurons(2).tag;
    
    incr_fig_indx();
    clf('reset');
    
    tmp_double_neuron.neurons(1).userdata.f = cell(size(pattern));
    tmp_double_neuron.neurons(2).userdata.f = cell(size(pattern));
    
    for j=1:length(pattern)
      
      sc_square_subplot(length(pattern), j);
      hold on
      tmp_pattern = pattern{j};
      tmp_pattern_time =  tmp_double_neuron.userdata.pattern_time{j};
      
      t1 = tmp_double_neuron.neurons(1).userdata.spiketime;
      [tmp_f1, t, h_plot] = sc_kernelhist(tmp_pattern_time, t1, pretrigger, posttrigger, ...
        kernelwidth, binwidth);
      set(h_plot, 'Tag', tag1);
      
      t2 = tmp_double_neuron.neurons(2).userdata.spiketime;
      [tmp_f2, ~, h_plot] = sc_kernelhist(tmp_pattern_time, t2, pretrigger, posttrigger, ...
        kernelwidth, binwidth);
      set(h_plot, 'Tag', tag2);
      
      tmp_double_neuron.neurons(1).userdata.f(j) = {tmp_f1};
      tmp_double_neuron.neurons(2).userdata.f(j) = {tmp_f2};
      tmp_double_neuron.userdata.t = t;
      
      axis tight
      title([tmp_double_neuron.neurons(1).file_tag ': ' tmp_pattern ...
        '(' num2str(length(tmp_pattern_time)) ')']);
    end
    
    add_legend(gcf, true);
    linkaxes(get_axes(gcf));
  end
  
  save paired_3
  
  
  % Make avg convoluted response
  % Perform MSD analysis
  F = [];
  file_tag = cell(1000, 1);
  experiment_tag = cell(1000, 1);
  cell_tag = cell(1000, 1);
  marker_tag = cell(1000, 1);
  pattern_tag = cell(1000, 1);
  
  counter = 0;
  
  for i=1:length(double_neuron)
    fprintf('%d (%d)***\n', i, length(double_neuron));
    
    tmp_double_neuron = double_neuron(i);
    t = tmp_double_neuron.userdata.t;
    
    for j=1:2
      tmp_neuron = tmp_double_neuron.neurons(j);
      
      for k=1:length(tmp_neuron.userdata.f)
        
        tmp_f = tmp_neuron.userdata.f{k};
        
        if ~isempty(tmp_f) && nnz(tmp_f)
          
          counter = counter + 1;
          
          F(:, counter) = tmp_f(t>=tmin & t<tmax); %#ok<SAGROW>
          file_tag(counter) = {tmp_neuron.file_tag};
          experiment_tag(counter) = {tmp_neuron.file_tag(1:4)};
          cell_tag(counter) = {sprintf('Cell %d', 2*(i-1)+j)};
          pattern_tag(counter) = pattern(k);
          
          if j==1
            marker_tag(counter) = {'+'};
          elseif j==2
            marker_tag(counter) = {'o'};
          else
            error('not defined');
          end
          
        end
        
      end
    end
  end
  
  F = F(:, 1:counter);
  file_tag = file_tag(1:counter);
  experiment_tag = experiment_tag(1:counter);
  cell_tag = cell_tag(1:counter);
  marker_tag = marker_tag(1:counter);
  pattern_tag = pattern_tag(1:counter);
  
  for i=1:length(double_neuron)
    fprintf('%d (%d)*4\n', i, length(double_neuron));
    
    tmp_double_neuron = double_neuron(i);
    t = tmp_double_neuron.userdata.t;
    
    for j=1:2
      
      tmp_neuron = tmp_double_neuron.neurons(j);
      
      clear tmp_neuron_list
      tmp_neuron_list(2*length(double_neuron), 1) = ScSpikeData();
      tmp_distance_list = nan(2*length(double_neuron), 1);
      tmp_experiment_tag_list = cell(2*length(double_neuron), 1);
      tmp_file_tag_list = cell(2*length(double_neuron), 1);
      
      for k=1:length(double_neuron)
        
        tmp_double_neuron_2 = double_neuron(k);
        
        for m=1:2
          
          tmp_neuron_2 = tmp_double_neuron_2.neurons(m);
          
          indx = 2*(k-1)+m;
          
          
          
          tmp_distance = 0;
          
          for n=1:length(tmp_neuron.userdata.f)
            
            tmp_distance = tmp_distance + sum( (tmp_neuron.userdata.f{n}(t>=tmin & t<tmax) - tmp_neuron_2.userdata.f{n}(t>=tmin & t<tmax)).^2 );
            
          end
          
          tmp_experiment_tag_list(indx) = {tmp_neuron_2.file_tag(1:4)};
          tmp_file_tag_list(indx) = {tmp_neuron_2.file_tag};
          tmp_neuron_list(indx) = tmp_neuron_2;
          tmp_distance_list(indx) = tmp_distance;
        end
      end
      
      tmp_neuron.userdata.distance = struct('neuron', tmp_neuron_list, ...
        'distance', tmp_distance_list, 'file_tag', tmp_file_tag_list, ...
        'experiment_tag', tmp_experiment_tag_list);
      
    end
    
  end
  save paired_4
  
  %%
  % Perform MDA for all cells together
  incr_fig_indx();
  
  %[~, score, ~, ~, explained] = pca(F');
  %tmp_score = score(:,explained>5);
  
  d = pdist(F');
  y = mdscale(d, scaling_dim);
  %y = score(:,1:2);
  
  plot_mda(y, file_tag, marker_tag);
  title('Non-linear MDS - all data');
  
  add_legend(gcf, true);
  
  u_experiment_tag = unique(experiment_tag);
  u_file_tag = unique(file_tag);
  u_cell_tag = unique(cell_tag);
  
  save paired_5
  % Perform MDA for each double recording separately
  
  for i=1:length(u_file_tag)
    fprintf('%d (%d)*5\n', i, length(u_file_tag));
    
    tmp_file_tag = u_file_tag{i};
    
    indx = cellfun(@(x) strcmp(x, tmp_file_tag), file_tag);
    
    tmp_F = F(:, indx);
    tmp_cell_tag = cell_tag(indx);
    tmp_marker = marker_tag(indx);
    
    % Do MDA
    incr_fig_indx();
    
    %[~, score_2, ~, ~, explained] = pca(tmp_F');
    %tmp_score = score_2(:,explained>5);
    
    d = pdist(tmp_F');
    try
      y = mdscale(d, scaling_dim);
      %y = score_2(:,1:2);
      
      plot_mda(y, tmp_cell_tag, tmp_marker);
      title(['Non-linear MDS (single cell pair: ' tmp_file_tag ')']);
      
      add_legend(gcf, true);
    catch
      warning('Could not plot file %s\n', tmp_file_tag);
    end
  end
  
  % Perform MDA for each experiment separately
  % Same as above for responses from same experiment
  
  for i=1:length(u_experiment_tag)
    fprintf('%d (%d)*6\n', i, length(u_experiment_tag));
    
    tmp_experiment_tag = u_experiment_tag{i};
    
    indx = cellfun(@(x) strcmp(x, tmp_experiment_tag), experiment_tag);
    
    tmp_F = F(:, indx);
    tmp_cell_tag = cell_tag(indx);
    tmp_file_tag = file_tag(indx);
    tmp_marker = marker_tag(indx);
    tmp_pattern = pattern_tag(indx);
    
    if length(unique(tmp_file_tag)) > 1
      
      % Do MDA
      incr_fig_indx();
      
      %[~, score_3, ~, ~, explained] = pca(tmp_F');
      
      %tmp_score = score_3(:, explained>5);
      
      d = pdist(tmp_F');
      y = mdscale(d, scaling_dim);
      
      %y = score_3(:,1:2);
      
      plot_mda(y, tmp_file_tag, tmp_marker);
      title(['Non-linear MDS (compiled from experiment ' tmp_experiment_tag ')']);
      
      add_legend(gcf, true);
      
      incr_fig_indx();
      plot_mda(y, tmp_pattern, '*');
      title(['Non-linear MDS (' tmp_experiment_tag ')']);
      add_legend(gcf, true);
    end
    
  end
  
end

figs = [];
figs = [figs; incr_fig_indx()];
clf('reset')
hold on

for i=1:length(double_neuron)
  fprintf('%d (%d)*7\n', i, length(double_neuron));
  
  tmp_double_neuron = double_neuron(i);
  
  for j=1:2
    
    tmp_neuron = tmp_double_neuron.neurons(j);
    tmp_neighbor_neuron = tmp_double_neuron.neurons(mod(j,2)+1);
    
    distance_list = tmp_neuron.userdata.distance.distance;
    neuron_list = tmp_neuron.userdata.distance.neuron;
    
    neighbor_distance = distance_list(neuron_list == tmp_neighbor_neuron);
    distance_list(neuron_list == tmp_neuron | neuron_list == tmp_neighbor_neuron) = [];
    
    y = 2*(i-1)+j;
    
    plot(log(distance_list), y*ones(size(distance_list)), 'Marker', '+', 'Tag', 'other neurons', 'LineStyle', 'none');
    plot(log(neighbor_distance), y, 'Marker', 'o', 'Tag', 'neighboring neuron', 'LineStyle', 'none');
  end
end

yticklabel = cell(2*length(double_neuron), 1);
yticklabel(1:2:end) = arrayfun(@(x) sprintf('%s (1)', x.tag), double_neuron, ...
  'UniformOutput', false);
yticklabel(2:2:end) = arrayfun(@(x) sprintf('%s (2)', x.tag), double_neuron, ...
  'UniformOutput', false);

ylim([0 2*length(double_neuron)+1])
set(gca, 'YTick', 1:2*length(double_neuron), 'YTickLabel', ...
  yticklabel);
grid on
title('Response distances, all neurons')
xlabel('log (distance between responses)')
ylabel('Neuron')

for i=1:length(u_experiment_tag)
  fprintf('%d (%d)*9\n', i, length(u_experiment_tag));
  
  tmp_experiment_tag = u_experiment_tag{i};
  
  indx = arrayfun(@(x) strcmp(x.neurons(1).file_tag(1:4), tmp_experiment_tag), double_neuron);
  
  if nnz(indx)>1
    
    tmp_double_neuron_list = double_neuron(indx);
    
    figs = [figs; incr_fig_indx()];
    clf('reset')
    hold on
    
    for j=1:length(tmp_double_neuron_list)
      
      tmp_double_neuron = tmp_double_neuron_list(j);
      
      for k=1:2
        
        tmp_neuron = tmp_double_neuron.neurons(k);
        tmp_neighbor_neuron = tmp_double_neuron.neurons(mod(k,2)+1);
        
        distance_list = tmp_neuron.userdata.distance.distance;
        neuron_list = tmp_neuron.userdata.distance.neuron;
        
        neighbor_distance = distance_list(neuron_list == tmp_neighbor_neuron);
        
        rm_indx = (neuron_list == tmp_neuron | neuron_list == tmp_neighbor_neuron) | ...
          cellfun(@(x) ~strcmp(x, tmp_experiment_tag), {tmp_neuron.userdata.distance.experiment_tag})';
        
        distance_list(rm_indx) = [];
        
        y = 2*(j-1)+k;
        
        plot(log(distance_list), y*ones(size(distance_list)), 'Marker', '+', 'Tag', 'other neurons', 'LineStyle', 'none');
        plot(log(neighbor_distance), y, 'Color', 'r', 'Marker', 'o', 'Tag', 'neighboring neuron', 'LineStyle', 'none');%, 'MarkerSize', 14);
      end
    end
    
    yticklabel = cell(2*length(tmp_double_neuron_list), 1);
    yticklabel(1:2:end) = arrayfun(@(x) sprintf('%s (1)', x.tag), tmp_double_neuron_list, ...
      'UniformOutput', false);
    yticklabel(2:2:end) = arrayfun(@(x) sprintf('%s (2)', x.tag), tmp_double_neuron_list, ...
      'UniformOutput', false);
    
    ylim([0 2*length(tmp_double_neuron_list)+1])
    set(gca, 'YTick', 1:2*length(tmp_double_neuron_list), 'YTickLabel', ...
      yticklabel);
    grid on
    title(['Response distances, ' tmp_experiment_tag])
    xlabel('log (distance between responses)')
    ylabel('Neuron')
  end
end

add_legend(figs, false);