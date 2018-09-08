classdef IntraPlotStates < handle
  
  properties
    
    height_limit = 2
    min_nbr_epsp = 5
    
    pretrigger = -.1
    posttrigger = .4
    
    response_window_start = .004
    response_window_end   = .05
    nbrofcoeffs = 20
    
    str_stims
    neurons
    
  end
  
  
  methods
    
    function init(obj, varargin)
      
      for i=1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end
      
      sc_settings.set_current_settings_tag(sc_settings.tags.INTRA);
      sc_debug.set_mode(true);
      
      obj.str_stims = get_intra_motifs();
      obj.neurons = intra_get_neurons();
      
      reset_fig_indx();
      
    end
    
    
    function exec(obj, neurons, str_stims, varargin)
      
      if ~iscell(str_stims)
        
        if isnumeric(str_stims)
          
          tmp_stims = cell(size(str_stims));
          
          for i=1:length(str_stims)
            tmp_stims(i) = {str_stims(i)};
          end
          
          str_stims = tmp_stims;
          
        else
          str_stims = {str_stims};
        end
        
      end
      
      if ~iscell(neurons)
        
        if isnumeric(neurons)
          
          tmp_neurons = cell(size(neurons));
          
          for i=1:length(tmp_neurons)
            tmp_neurons(i) = {neurons(i)};
          end
          
          neurons = tmp_neurons;
          
        else
          neurons = {neurons};
        end
        
      end
      
      for i=1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end
      
      for i=1:length(neurons)
        
        sc_debug.print('Neuron', i, length(neurons));
        
        tmp_neuron = neurons{i};
        
        if isnumeric(tmp_neuron)
          tmp_neuron = obj.neurons(tmp_neuron);
        elseif ischar(tmp_neuron)
          tmp_neuron = obj.neurons(cellfun(@(x) strcmp(x, tmp_neuron), ...
            {obj.neurons.file_tag}));
        end
        
        for j=1:length(str_stims)
          
          sc_debug.print('', 'stim', j, length(str_stims));
          
          str_stim = str_stims{j};
          
          if isnumeric(str_stim)
            str_stim = obj.str_stims{str_stim};
          end
          
          signal    = sc_load_signal(tmp_neuron);
          amplitude = signal.amplitudes.get('tag', str_stim);
          v         = signal.get_v(true, true, true, true);
          
          [sweeps, time] = sc_get_sweeps(v, 0, amplitude.gettimes(0, inf), ...
            obj.pretrigger, obj.posttrigger, signal.dt);
          
          ranges = range(sweeps, 1);
          sweeps = sweeps(:, ranges < 25);
          
          %[~, ind_zero] = min(abs(time));
          
          %sweeps = double(bsxfun(@minus, sweeps, sweeps(ind_zero, :)));
          
          %for k=1:size(sweeps, 2)
          %  sweeps(:, k) = sweeps(:, k) - min(sweeps(:, k));
          %end
          
          for k=1:size(sweeps, 2)
            
            vmin = min(sweeps(:, k));
            vmax = max(sweeps(:, k));
            sweeps(:, k) = 20*(sweeps(:, k) - vmin)/(vmax-vmin);
          
          end
          
          sweeps = double(sweeps);
          
          pos = time > obj.response_window_start & ...
            time <= obj.response_window_end;
          
          sweeps_pos = sweeps(pos, :);
          
          d = pdist(sweeps_pos');
          
          sweeps_single_dim = cmdscale(d, 1);
          
          [sweeps_single_dim, indx] = sort(sweeps_single_dim);
          
          sweeps = sweeps(:, indx);
          
          f = incr_fig_indx();
          f.Name = [tmp_neuron.file_tag ' ' amplitude.tag];
          f.FileName = [tmp_neuron.file_tag ' ' amplitude.tag];
          
          clf
          
          n = cumsum(histcounts(sweeps_single_dim));
          
          str_title = [tmp_neuron.file_tag ' ' amplitude.tag ' sorted according to state'];
          
          subplot(1,2,1)
          title(str_title);
          hold on

          only_once = false;
          for k=1:size(sweeps, 2)
            
            y0 = - sum(k >= n) * 25;
            
            if ~only_once && sum(k>=n)>length(n)/2
              
              only_once = true;
              subplot(1,2,2)
              title(str_title)
              hold on
              
            end
            
            plot(time, y0 + sweeps(:, k));
            
          end
          subplot(1,2,1)
          axis tight
          grid on
          
          subplot(1,2,2)
          axis tight
          grid on
          
        end
        
      end
      
    end
    
  end
  
end


function plot_sub(sweeps, time, indx, subplotindx, str_title)

subplot(1,2,subplotindx)
title(str_title);
hold on
grid on

%y = 0;
count = 0;

for i=1:length(indx)
  
  count = count + 1;
  y0 = 25*floor(count/10);
  plot(time, y0 + sweeps(:, indx(i)));
  %y = sweeps(:, indx(i)) - min(sweeps(:, indx(i))) + max(y);
  %plot(time, y);
  
end

axis tight

end