%function paired_recordings()
sc_clf_all('reset')
reset_fig_indx()

run_all = false;

run_1 = eval('false');  %Collect double recordings
run_2 = eval('false');  %Plot collected recordings
run_3 = eval('false');  %Plot & save_name response to patterns, turn into matrices
run_4 = eval('false');   %generate kernel density matrix
run_5 = eval('false');
run_6 = eval('false');
run_7 = eval('false');
run_8 = eval('false');
run_9 = eval('false');
run_10 = eval('false');
run_11 = eval('false');
run_12 = eval('false');
run_13 = eval('false');
run_14 = eval('true');

suppress_kernelhist = true;

if run_all || run_1
  %Collect double recordings
  max_idle_time = 600;
  pretrigger = -1;
  posttrigger = 1.5;
  kernelwidth = 5e-3;
  binwidth = 1e-4;
  scaling_dim = 2;
  tmin = 0;
  tmax = 1;
  stim_latency = 1;
  
  [~, txt] = xlsread('paired-recordings.xlsx');
  
  txt = txt(2:end, :);
  txt = txt(cellfun(@(x) strcmp(x, 'y'), txt(:, 3)), [1:2 4:size(txt, 2)]);
  
  double_recordings = cellfun(@(varargin) get_double_recordings(max_idle_time, varargin{:}), ...
    txt(:, 1), txt(:, 2), txt(:, 3), txt(:, 4), txt(:, 5), ...
    'UniformOutput', false);
  save_vars paired1
else
  load paired1 -regexp ^(?!run_\d$).
end

if run_all || run_2
  %Plot collected recordings
  for i=1:length(double_recordings)
    tmp_double_recording = double_recordings{i};
    
    for j=1:length(tmp_double_recording)
      %incr_fig_indx
      plot_raster_paired_recordings(tmp_double_recording(j), ...
        tmp_double_recording(j).time_sequences, tmp_double_recording(j).file_tag);
    end
  end
end
%%
if run_all || run_3
  %Plot & save response to patterns, turn into matrices
  
  min_nbr_of_stims_threshold = 50;
  
  for i=1:length(double_recordings)
    
    fprintf('block_3 %d out of %d\n', i, length(double_recordings));
    
    tmp_double_recording = double_recordings{i};
    [pattern_times, str_pattern] = get_pattern_times(tmp_double_recording(1));
    
    delete_recording = false(size(tmp_double_recording));
    
    for j=1:length(tmp_double_recording)
      
      if ~suppress_kernelhist
        incr_fig_indx();
        clf('reset');
      end
      
      [t1, t2, wf1, wf2] = get_neuron_spiketime(tmp_double_recording(j));
      
      f1 = cell(size(str_pattern));
      f2 = cell(size(str_pattern));
      
      min_nbr_of_stims = inf;
      
      for k=1:length(str_pattern)
        
        if ~suppress_kernelhist
          sc_square_subplot(length(str_pattern), k);
          hold on
        end
        
        tmp_pattern_time = extract_within_sequence(pattern_times{k}, ...
          bsxfun(@plus, tmp_double_recording(j).time_sequences, -[pretrigger posttrigger]));
        
        min_nbr_of_stims = min(length(tmp_pattern_time), min_nbr_of_stims);
        
        [tmp_f1, t, h_plot] = sc_kernelhist(suppress_kernelhist, tmp_pattern_time, t1, pretrigger, posttrigger, ...
          kernelwidth, binwidth);
        f1(k) = {tmp_f1};
        
        if ~suppress_kernelhist
          set(h_plot, 'Tag', wf1.tag);
        end
        
        [tmp_f2, ~, h_plot] = sc_kernelhist(suppress_kernelhist, tmp_pattern_time, t2, pretrigger, posttrigger, ...
          kernelwidth, binwidth);
        f2(k) = {tmp_f2};
        
        if ~suppress_kernelhist
          set(h_plot, 'Tag', wf2.tag);
        end
        
        if ~suppress_kernelhist
          title(gca, [tmp_double_recording(j).tag ': ' str_pattern{k} ' (N = ' num2str(length(tmp_pattern_time)) ')']);
          grid on
          axis tight
        end
      end
      
      set_userdata(tmp_double_recording(j), []);
      set_userdata(tmp_double_recording(j), 't', t, 'f1', f1, 'f2', f2, ...
        'min_nbr_of_stims', min_nbr_of_stims);
      
      if ~suppress_kernelhist
        add_legend(gcf, true);
        linkaxes(get_axes(gcf));
      end
      
      if min_nbr_of_stims < min_nbr_of_stims_threshold
        delete_recording(j) = true;
      end
    end
    
    tmp_double_recording(delete_recording) = [];
    double_recordings(i) = {tmp_double_recording};
  end
  
  double_recordings = double_recordings(~cellfun(@isempty, double_recordings));
  save_vars paired3
else
  load paired3 -regexp ^(?!run_\d$).
end

%%
if run_all || run_4
  %generate kernel density matrix
  F = [];
  file_tag = cell(1000, 1);
  experiment_tag = cell(1000, 1);
  cell_tag = cell(1000, 1);
  marker_tag = cell(1000, 1);
  pattern_tag = cell(1000, 1);
  
  counter = 0;
  
  for i=1:length(double_recordings)
    fprintf('run_4 %d (%d)***\n', i, length(double_recordings));
    
    tmp_double_recording = double_recordings{i};
    
    for i2=1:length(tmp_double_recording)
      
      tmp_double_neuron = tmp_double_recording(i2);
      
      t = tmp_double_neuron.userdata.t;
      
      for j=1:2
        f = tmp_double_neuron.userdata.(sprintf('f%d', j));
        
        for k=1:length(f)
          
          tmp_f = f{k};
          
          if ~isempty(tmp_f) && nnz(tmp_f) && length(tmp_f) == length(t)
            
            counter = counter + 1;
            
            F(:, counter) = tmp_f(t>=tmin & t<tmax);
            file_tag(counter) = {tmp_double_neuron.file_tag};
            experiment_tag(counter) = {tmp_double_neuron.experiment_filename};
            cell_tag(counter) = {sprintf('Cell %d', 2*(i-1)+j)};
            pattern_tag(counter) = str_pattern(k);
            
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
  end
  
  F = F(:, 1:counter);
  file_tag = file_tag(1:counter);
  experiment_tag = experiment_tag(1:counter);
  cell_tag = cell_tag(1:counter);
  marker_tag = marker_tag(1:counter);
  pattern_tag = pattern_tag(1:counter);
  save_vars paired4.mat
else
  load paired4 -regexp ^(?!run_\d$).
end

if run_all || run_5
  
  figs = [];
  
  for i=1:length(double_recordings)
    %Plot cross correlations
    fprintf('block_4: %d out of %d\n', i, length(double_recordings));
    
    tmp_double_recording = double_recordings{i};
    stim_times = get_stim_times(tmp_double_recording(1));
    stim_times = cell2mat(stim_times(:));
    
    for j=1:length(tmp_double_recording)
      
      figs = [figs incr_fig_indx()];
      clf('reset');
      
      hold on
      
      [t1, t2, wf1, wf2] = get_neuron_spiketime(tmp_double_recording(j));
      
      indx = arrayfun(@(x) all(~(x>stim_times & x<stim_times+stim_latency)), t1);
      t1 = t1(indx);
      
      indx = arrayfun(@(x) all(~(x>stim_times & x<stim_times+stim_latency)), t2);
      t2 = t2(indx);
      
      [~, ~, h_plot] = sc_kernelhist(t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);
      set(h_plot, 'Tag', [wf2.tag ' (N = ' num2str(length(t1)) ')']);
      
      [~, ~, h_plot] = sc_kernelhist(t2, t1, pretrigger, posttrigger, kernelwidth, binwidth);
      set(h_plot, 'Tag',[wf1.tag ' (N = ' num2str(length(t2)) ')']);
      
      grid on
      title(tmp_double_recording(j).file_tag);
      add_legend();
    end
    
  end
  linkaxes(get_axes(figs));
end

if run_all || run_6
  figs = [];
  
  for i=1:length(double_recordings)
    %Plot cross correlations
    fprintf('block_5: %d out of %d\n', i, length(double_recordings));
    
    tmp_double_recording = double_recordings{i};
    stim_times = get_stim_times(tmp_double_recording(1));
    stim_times = cell2mat(stim_times(:));
    
    for j=1:length(tmp_double_recording)
      
      if ~suppress_kernelhist
        figs = [figs incr_fig_indx()];
        clf('reset');
        hold on
      end
      
      
      [t1, t2, wf1, wf2] = get_neuron_spiketime(tmp_double_recording(j));
      
      indx = arrayfun(@(x) all(~(x>stim_times & x<stim_times+stim_latency)), t1);
      t1 = t1(indx);
      
      indx = arrayfun(@(x) all(~(x>stim_times & x<stim_times+stim_latency)), t2);
      t2 = t2(indx);
      
      [f1, ~, h_plot] = sc_kernelhist(suppress_kernelhist, t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);
      
      if ~suppress_kernelhist
        
        set(h_plot, 'Tag', [wf2.tag ' (N = ' num2str(length(t1)) ')']);
        plot([pretrigger posttrigger], mean(f1)*[1 1], 'Tag', [wf1.tag ' (N = ' num2str(length(t2)) ')'])
        plot([pretrigger posttrigger], mean(f1)*[1 1]+3*std(f1), 'Tag', [wf1.tag ' (N = ' num2str(length(t2)) ')'])
      end
      
      [f2, ~, h_plot] = sc_kernelhist(suppress_kernelhist, t2, t1, pretrigger, posttrigger, kernelwidth, binwidth);
      if ~suppress_kernelhist
        
        set(h_plot, 'Tag',[wf1.tag ' (N = ' num2str(length(t2)) ')']);
        plot([pretrigger posttrigger], mean(f2)*[1 1], 'Tag', [wf2.tag ' (N = ' num2str(length(t1)) ')'])
        plot([pretrigger posttrigger], mean(f2)*[1 1]+3*std(f2), 'Tag', [wf2.tag ' (N = ' num2str(length(t1)) ')'])
      end
      
      if ~suppress_kernelhist
        grid on
        title(tmp_double_recording(j).file_tag);
        add_legend();
      end
      
    end
  end
  
  if ~isempty(figs)
    linkaxes(get_axes(figs));
  end
  save_vars paired6
else
  load paired6 -regexp ^(?!run_\d$).
end

if run_all || run_7
  % Perform MDA for all cells together
  incr_fig_indx();
  
  %[~, score, ~, ~, explained] = pca(F');
  %tmp_score = score(:,explained>5);
  
  d = pdist(F');
  y = cmdscale(d, scaling_dim);
  %y = score(:,1:2);
  
  plot_mda(y, file_tag, marker_tag);
  title('Non-linear MDS - all data');
  
  add_legend(gcf, true);
end

if run_all || run_8
  u_file_tag = unique(file_tag);
  
  % Perform MDA for each double recording separately
  
  for i=1:length(u_file_tag)
    fprintf('block_8 %d (%d)\n', i, length(u_file_tag));
    
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
      y = cmdscale(d, scaling_dim);
      %y = score_2(:,1:2);
      
      plot_mda(y, tmp_cell_tag, tmp_marker);
      title(['Non-linear MDS (single cell pair: ' tmp_file_tag ')']);
      
      add_legend(gcf, true);
    catch
      warning('Could not plot file %s\n', tmp_file_tag);
    end
  end
end

if run_all || run_9
  u_experiment_tag = unique(experiment_tag);
  
  % Perform MDA for each experiment separately
  % Same as above for responses from same experiment
  
  for i=1:length(u_experiment_tag)
    fprintf('%d (%d)*6\n', i, length(u_experiment_tag));
    
    tmp_experiment_tag = u_experiment_tag{i};
    
    indx = cellfun(@(x) strcmp(x, tmp_experiment_tag), experiment_tag);
    
    tmp_F = F(:, indx);
    tmp_file_tag = file_tag(indx);
    tmp_marker = marker_tag(indx);
    tmp_pattern = pattern_tag(indx);
    
    if length(unique(tmp_file_tag)) > 1
      
      % Do MDA
      incr_fig_indx();
      
      %[~, score_3, ~, ~, explained] = pca(tmp_F');
      
      %tmp_score = score_3(:, explained>5);
      
      d = pdist(tmp_F');
      y = cmdscale(d, scaling_dim);
      
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

if run_all || run_10
  
  u_cell_tag = unique(cell_tag);
  incr_fig_indx();
  clf('reset');
  hold on
  
  for i=1:length(u_cell_tag)
    disp(i)
    indx1 = cellfun(@(x) strcmp(x, u_cell_tag{i}), cell_tag);
    f_this_neuron = F(:, indx1);
    std_f_this_neuron = mean(std(f_this_neuron, 0, 2));
    this_file_tag = file_tag{find(indx1, 1)};
    
    indx2 = cellfun(@(x) strcmp(x, this_file_tag), file_tag);
    f_neighboring_neuron = F(:, ~indx1 & indx2);
    std_f_neighboring_neuron = mean(std(f_neighboring_neuron, 0, 2));
    this_experiment_tag = experiment_tag{find(indx1, 1)};
    
    indx3 = cellfun(@(x) strcmp(x, this_experiment_tag), experiment_tag);
    f_same_experiment = F(:, ~indx1 & ~indx2 & indx3);
    std_f_same_experiment = mean(std(f_same_experiment, 0, 2));
    
    f_rest = F(:, ~indx1 & ~indx2 & ~indx3);
    std_f_rest = mean(std(f_rest, 0, 2));
    
    plot(std_f_this_neuron, i, '+', 'Tag', 'Same neuron');
    plot(std_f_neighboring_neuron, i, '+', 'Tag', 'Neighbor');
    
    if ~isempty(std_f_same_experiment)
      plot(std_f_same_experiment, i, 'o', 'Tag', 'Same experiment');
    end
    
    plot(std_f_rest, i, '*', 'Tag', 'Rest');
  end
  add_legend
end

if run_all || run_11
  
  for i=1:length(double_recordings)
    tmp_double_recording = double_recordings{i};
    
    for j=1:length(tmp_double_recording)
      
      incr_fig_indx();
      clf('reset');
      
      [t1, t2, wf1, wf2] = get_neuron_spiketime(tmp_double_recording(j));
      
      [pattern_times, str_pattern] = get_pattern_times(tmp_double_recording(1));
      
      for k=1:length(str_pattern)
        
        sc_square_subplot(length(str_pattern), k);
        hold on
        
        tmp_pattern_time = extract_within_sequence(pattern_times{k}, ...
          bsxfun(@plus, tmp_double_recording(j).time_sequences, -[pretrigger posttrigger]));
        
        [~, ~, h_plot] = sc_raster(tmp_pattern_time, t1, pretrigger, posttrigger);
        set(h_plot, 'Tag', wf1.tag);
        
        [~, ~, h_plot] = sc_raster(tmp_pattern_time, t2, pretrigger, posttrigger);
        set(h_plot, 'Tag', wf2.tag);
        
        title([tmp_double_recording(j).tag ': ' str_pattern{k}])
      end
      add_legend(gcf, true);
    end
  end
end

if run_all || run_12
  
  u_cell = unique(cell_tag);
  u_pattern = unique(pattern_tag);
  
  d_inter_cell = nan(length(u_cell), length(u_pattern), length(u_cell));
  b_inter_cell_same_cell = false(size(d_inter_cell));
  b_inter_cell_same_file = false(size(d_inter_cell));
  b_inter_cell_same_experiment = false(size(d_inter_cell));
  
  d_inter_pattern = nan(length(u_cell), length(u_pattern), length(u_cell), length(u_pattern));
  b_inter_pattern_same_cell = false(size(d_inter_pattern));
  b_inter_pattern_same_file = false(size(d_inter_pattern));
  b_inter_pattern_same_experiment = false(size(d_inter_pattern));
  
  for i=1:length(u_cell)
    fprintf('&&& %d %d\n', i, length(u_cell));
    
    ind_cell_1 = cellfun(@(x) strcmp(x, u_cell{i}), cell_tag);
    
    this_cell_1 = u_cell{i};
    this_file_1 = file_tag{find(ind_cell_1, 1)};
    this_experiment_1 = experiment_tag{find(ind_cell_1, 1)};
    
    for j=1:length(u_pattern)
      
      ind_pattern = cellfun(@(x) strcmp(x, u_pattern{j}), pattern_tag);
      
      for k=1:length(u_cell)
        
        ind_cell_2 = cellfun(@(x) strcmp(x, u_cell{k}), cell_tag);
        
        this_cell_2 = u_cell{k};
        this_file_2 = file_tag{find(ind_cell_2, 1)};
        this_experiment_2 = experiment_tag{find(ind_cell_2, 1)};
        
        ind1 = ind_cell_1 & ind_pattern;
        first_element = find(ind1, 1);
        ind1(first_element+1:end) = false;
        
        ind2 = ind_cell_2 & ind_pattern;
        first_element = find(ind2, 1);
        ind2(first_element+1:end) = false;
        
        d_inter_cell(i, j, k) = sqrt( mean(sum( (F(:, ind1) - F(:, ind2)).^2 )) );
        b_inter_cell_same_cell(i, j, k) = strcmp(this_cell_1, this_cell_2);
        b_inter_cell_same_file(i, j, k) = strcmp(this_file_1, this_file_2);
        b_inter_cell_same_experiment(i, j, k) = strcmp(this_experiment_1, this_experiment_2);
      end
    end
  end
  
  for i=1:length(u_cell)
    fprintf('abra kadabra %d %d\n', i, length(u_cell));
    
    ind_cell_1 = cellfun(@(x) strcmp(x, u_cell{i}), cell_tag);
    
    this_cell_1 = u_cell{i};
    this_file_1 = file_tag{find(ind_cell_1, 1)};
    this_experiment_1 = experiment_tag{find(ind_cell_1, 1)};
    
    for j=1:length(u_pattern)
      
      ind_pattern = cellfun(@(x) strcmp(x, u_pattern{j}), pattern_tag);
      
      for k=1:length(u_cell)
        
        ind_cell_2 = cellfun(@(x) strcmp(x, u_cell{k}), cell_tag);
        
        this_cell_2 = u_cell{k};
        this_file_2 = file_tag{find(ind_cell_2, 1)};
        this_experiment_2 = experiment_tag{find(ind_cell_2, 1)};
        
        for m=1:length(u_pattern)
          
          ind_pattern_2 = cellfun(@(x) strcmp(x, u_pattern{m}), pattern_tag);
          
          ind1 = ind_cell_1 & ind_pattern;
          first_element = find(ind1, 1);
          ind1(first_element+1:end) = false;
          
          ind2 = ind_cell_2 & ind_pattern_2;
          first_element = find(ind2, 1);
          ind2(first_element+1:end) = false;
          
          d_inter_pattern(i, j, k, m) = sqrt( mean(sum( ( F(:, ind1) - F(:, ind2)).^2 )) );
          
          b_inter_pattern_same_cell(i, j, k, m) = strcmp(this_cell_1, this_cell_2);
          b_inter_pattern_same_file(i, j, k, m) = strcmp(this_file_1, this_file_2);
          b_inter_pattern_same_experiment(i, j, k, m) = strcmp(this_experiment_1, this_experiment_2);
        end
      end
    end
  end
  
  save_vars paired12
  
else
  load paired12 -regexp ^(?!run_\d$).
end

if run_all || run_13
  figs = [];
  
  for pattern1_ind=1:length(u_pattern)
    fprintf('ööö %d / %d\n', pattern1_ind, length(u_pattern));
    
    figs = [figs clf(incr_fig_indx(), 'reset')];
    hold on
    title(['Inter cell: ' u_pattern{pattern1_ind}])
    set(gca, 'YTick', 1:length(u_cell), 'YTickLabel', u_cell);
    grid on
    
    for cell1_ind=1:length(u_cell)
      for cell2_ind=1:length(u_cell)
        d = d_inter_cell(cell1_ind, pattern1_ind, cell2_ind);
        
        if b_inter_cell_same_cell(cell1_ind, pattern1_ind, cell2_ind)
          tag = 'Same cell';
          plot(d, cell1_ind, '+', 'Tag', tag);
        elseif b_inter_cell_same_file(cell1_ind, pattern1_ind, cell2_ind)
          tag = 'Same file';
          plot(d, cell1_ind, 'o', 'Tag', tag);
        elseif b_inter_cell_same_experiment(cell1_ind, pattern1_ind, cell2_ind)
          tag = 'Same experiment';
          plot(d, cell1_ind, 's', 'Tag', tag);
        else
          %tag = 'Different experiments';
          %plot(d, cell1_ind, '*', 'Tag', tag);
        end
      end
      
    end
  end
  
  for pattern1_ind=1:length(u_pattern)
    fprintf('üüü %d / %d\n', pattern1_ind, length(u_pattern));
    
    figs = [figs clf(incr_fig_indx(), 'reset')];
    hold on
    title(['Inter pattern: ' u_pattern{pattern1_ind}])
    set(gca, 'YTick', 1:length(u_cell), 'YTickLabel', u_cell);
    grid on
    
    for cell1_ind=1:length(u_cell)
      for cell2_ind=1:length(u_cell)
        for pattern2_ind=1:length(u_pattern)
          d = d_inter_pattern(cell1_ind, pattern1_ind, cell2_ind, pattern2_ind);
          
          if b_inter_pattern_same_cell(cell1_ind, pattern1_ind, cell2_ind, pattern2_ind)
            tag = 'Same cell';
            plot(d, cell1_ind, '+', 'Tag', tag);
          elseif b_inter_pattern_same_file(cell1_ind, pattern1_ind, cell2_ind, pattern2_ind)
            tag = 'Same file';
            plot(d, cell1_ind, 'o', 'Tag', tag);
          elseif b_inter_pattern_same_experiment(cell1_ind, pattern1_ind, cell2_ind, pattern2_ind)
            tag = 'Same experiment';
            plot(d, cell1_ind, 's', 'Tag', tag);
          else
            %tag = 'Different experiments';
            %plot(d, cell1_ind, '*', 'Tag', tag);
          end
          
        end
      end
    end
  end
  
  add_legend(figs, false);
end

if run_14
  crosscorr_pretrigger  = -.5;
  crosscorr_posttrigger = .5;
  crosscorr_kernelwidth = kernelwidth;
  crosscorr_binwidth    = binwidth;
  isi_binwidth          = binwidth;
  isi_roi               = 1e-2;
  isi_max               = .3;
  
  for i=1:length(double_recordings)
    fprintf('run14 %d / %d\n', i, length(double_recordings));
    
    tmp_double_recording = double_recordings{i};
    
    for j=1:length(tmp_double_recording)
      incr_fig_indx();
      clf('reset')
      plot_paired_autocorr(tmp_double_recording(j), crosscorr_pretrigger, ...
        crosscorr_posttrigger, crosscorr_kernelwidth, crosscorr_binwidth, isi_roi, ...
        isi_binwidth, isi_max);
    end
  end
  
end

%end


