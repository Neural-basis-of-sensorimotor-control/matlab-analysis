clc
sc_clf_all
clear
reset_fig_indx

max_idle_time = 10;
pretrigger = -1;
posttrigger = 1.5;
kernelwidth = 5e-3;
binwidth = 1e-4;
scaling_dim = 2;
tmin = 0;
tmax = 1;

pattern = get_intra_patterns();
pattern = pattern(~startsWith(pattern, '1p electrode'));

double_neuron = get_paired_neurons();

y_lower = 0;
y_upper = 4;

for i=1:length(double_neuron)
  fprintf('%d (%d)*\n', i, length(double_neuron));
  
  tmp_double_neuron = double_neuron(i);
  set_userdata(tmp_double_neuron, []);
  
  signal = sc_load_signal(tmp_double_neuron);
  
  neuron1 = signal.waveforms.get('tag', tmp_double_neuron.template_tag{1});
  t1 = neuron1.gettimes(0, inf);
  neuron2 = signal.waveforms.get('tag', tmp_double_neuron.template_tag{2});
  t2 = neuron2.gettimes(0, inf);
  
  sequence1 = get_sequence(t1, max_idle_time);
  sequence2 = get_sequence(t2, max_idle_time);
  
  common_sequence = range_intersection(sequence1', sequence2');
  
  indx = 1:2:length(common_sequence);
  common_sequence = common_sequence([indx' indx'+1]);
  tmp_double_neuron.time_sequences = common_sequence;
  
  t1 = extract_within_sequence(t1,tmp_double_neuron.time_sequences);
  t2 = extract_within_sequence(t2, tmp_double_neuron.time_sequences);
  
  set_userdata(tmp_double_neuron, 't1', t1);
  set_userdata(tmp_double_neuron, 't2', t2);
  
  pattern_time = cell(size(pattern));
  
  for j=1:length(pattern)
    
    tmp_pattern = pattern{j};
    
    tmp_pattern_time = signal.parent.gettriggers(0,inf).get('tag', tmp_pattern).gettimes(0,inf);
    tmp_pattern_time = extract_within_sequence(tmp_pattern_time, ...
      bsxfun(@plus, tmp_double_neuron.time_sequences, -[pretrigger posttrigger]));
    
    pattern_time(j) = {tmp_pattern_time};
  end
  
  tmp_double_neuron.userdata.pattern_time = pattern_time;
  
  incr_fig_indx();
  clf('reset')
  hold on
  
  for j=1:size(tmp_double_neuron.time_sequences, 1)
    
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
  
  title(tmp_double_neuron.file_tag);
  
  set(gca, 'YTick', 1:3, 'YTickLabel', ...
    {tmp_double_neuron.template_tag{1}, tmp_double_neuron.template_tag{2}, 'Pattern onset'});
end

for i=1:length(double_neuron)
  fprintf('%d (%d)**\n', i, length(double_neuron));
  
  tmp_double_neuron = double_neuron(i);
  
  tag1 = tmp_double_neuron.template_tag{1};
  tag2 = tmp_double_neuron.template_tag{2};
  
  incr_fig_indx();
  clf('reset');
  
  tmp_double_neuron.userdata.f1 = cell(size(pattern));
  tmp_double_neuron.userdata.f2 = cell(size(pattern));
  
  for j=1:length(pattern)
    
    sc_square_subplot(length(pattern), j);
    hold on
    tmp_pattern = pattern{j};
    tmp_pattern_time =  tmp_double_neuron.userdata.pattern_time{j};
    
    t1 = tmp_double_neuron.userdata.t1;
    [tmp_f1, t, h_plot] = sc_kernelhist(tmp_pattern_time, t1, pretrigger, posttrigger, ...
      kernelwidth, binwidth);
    set(h_plot, 'Tag', tag1);
    
    t2 = tmp_double_neuron.userdata.t2;
    [tmp_f2, ~, h_plot] = sc_kernelhist(tmp_pattern_time, t2, pretrigger, posttrigger, ...
      kernelwidth, binwidth);
    set(h_plot, 'Tag', tag2);
    
    tmp_double_neuron.userdata.f1(j) = {tmp_f1};
    tmp_double_neuron.userdata.f2(j) = {tmp_f2};
    tmp_double_neuron.userdata.t = t;
    
    axis tight
    title([tmp_double_neuron.file_tag ': ' tmp_pattern ...
      '(' num2str(length(tmp_pattern_time)) ')']);
  end
  
  add_legend(gcf, true);
  linkaxes(get_axes(gcf));
end

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
    f = tmp_double_neuron.userdata.(sprintf('f%d', j));
    
    for k=1:length(f)
      
      tmp_f = f{k};
      
      if ~isempty(tmp_f) && nnz(tmp_f) && length(tmp_f) == length(t)
        
        counter = counter + 1;
        
        F(:, counter) = tmp_f(t>=tmin & t<tmax); %#ok<SAGROW>
        file_tag(counter) = {tmp_double_neuron.file_tag};
        experiment_tag(counter) = {tmp_double_neuron.file_tag(1:4)};
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
  tmp_double_neuron.userdata.distance = cell(2,1);
  
  t = tmp_double_neuron.userdata.t;
  
  for j=1:2
    
    f1 = tmp_double_neuron.userdata.(sprintf('f%d', j));
    
    clear tmp_neuron_list
    tmp_neuron_list = cell(2*length(double_neuron), 1);
    tmp_distance_list = nan(2*length(double_neuron), 1);
    tmp_experiment_tag_list = cell(2*length(double_neuron), 1);
    tmp_file_tag_list = cell(2*length(double_neuron), 1);
    
    for k=1:length(double_neuron)
      
      tmp_double_neuron_2 = double_neuron(k);
      
      for m=1:2
        
        indx = 2*(k-1)+m;
        
        f2 = tmp_double_neuron_2.userdata.(sprintf('f%d', m));
        
        if ~any(cellfun(@isempty, f1)) && ~any(cellfun(@isempty, f2))
          
          tmp_distance = 0;
          
          for n=1:length(f)
            
            tmp_distance = tmp_distance + sum( (f1{n}(t>=tmin & t<tmax) - ...
              f2{n}(t>=tmin & t<tmax)).^2 );
            
          end
          
          tmp_experiment_tag_list(indx) = {tmp_double_neuron_2.file_tag(1:4)};
          tmp_file_tag_list(indx) = {tmp_double_neuron_2.file_tag};
          tmp_neuron_list(indx) = tmp_double_neuron_2.template_tag(m);
          tmp_distance_list(indx) = tmp_distance;
        end
      end
    end
    
    tmp_double_neuron.userdata.distance(j) = {struct('neuron', tmp_neuron_list, ...
      'distance', tmp_distance_list, 'file_tag', tmp_file_tag_list, ...
      'experiment_tag', tmp_experiment_tag_list)};
    
  end
  
end

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

figs = [];
figs = [figs; incr_fig_indx()];
clf('reset')
hold on

for i=1:length(double_neuron)
  fprintf('%d (%d)*7\n', i, length(double_neuron));
  
  tmp_double_neuron = double_neuron(i);
  
  for j=1:2
    
    indx_neuton = j;
    indx_tmp_neuron = mod(j,2)+1;
    
    
    %tmp_neuron = tmp_double_neuron.neurons(j);
    %tmp_neighbor_neuron = tmp_double_neuron.neurons(mod(j,2)+1);
    
    distance = tmp_double_neuron.userdata.distance{j};
    distance_list = distance.distance;%tmp_neuron.userdata.distance.distance;
    neuron_list = distance.neuron;
    
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