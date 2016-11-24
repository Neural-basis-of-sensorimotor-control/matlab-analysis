classdef IntraAmplitudeViewer < handle

  properties
    min_latency = 4e-3
    max_latency = 22e-3
  end
  
  methods
    
    function set_intra(obj, index)
      str = get_intra_motifs();
      tag = str{index};
      amplitudes = obj.main_channel.signal.amplitudes;
      obj.set_amplitude(amplitudes.get('tag', tag));
    end
    
    
    function next_intra(obj)
      current_amplitude = obj.amplitude;
      str = get_intra_motifs();
      indx = sc_cellfind(str, current_amplitude.tag);
      indx = mod(indx, length(str)) + 1
      obj.set_intra(indx);
    end
    
    
    function print_detection_result(obj)
      
      signal = obj.main_signal;
      stims_str = get_intra_motifs();
      patterns_str = get_intra_patterns();
      response_range = obj.max_latency - obj.min_latency;
      
      neuron = get_intra_neurons(signal.parent.tag);
      
      if length(neuron) ~= 1
        error('Too many or too few neurons matched signal');
      end
      
      
      dim = size(stims_str);
      
      fraction_automatic = nan(dim);
      fraction_manual = nan(dim);
      fraction_both = nan(dim);
      fraction_only_automatic = nan(dim);
      fraction_only_manual = nan(dim);
      fraction_none = nan(dim);
      
      
      psp = signal.waveforms.get('tag', neuron.psp_templates{1});
      
      for i=1:length(stims_str)
        fprintf('Processing %d out of %d stims\n', i, length(stims_str));
        amplitude = signal.amplitudes.get('tag', stims_str{i});
        manual = amplitude.valid_data;
        automatic = false(size(manual));
        
        for j=1:length(amplitude.stimtimes)
          t0 = amplitude.stimtimes(j);
          tmin = t0 + obj.min_latency;
          tmax = t0 + obj.max_latency;
          
          automatic(j) = xpsp_detected(psp, tmin, tmax);
        end
        
        nbr_of_stims = length(amplitude.stimtimes);
        
        fraction_automatic(i) = nnz(automatic)/nbr_of_stims;
        fraction_manual(i) = nnz(manual)/nbr_of_stims;
        fraction_both(i) = nnz(automatic & manual)/nbr_of_stims;
        fraction_only_automatic(i) = nnz(automatic & ~manual)/nbr_of_stims;
        fraction_only_manual(i) = nnz(~automatic & manual)/nbr_of_stims;
        fraction_none(i) = nnz(~automatic & ~manual)/nbr_of_stims;
        
        nbr_of_automatic_detections = 0;
        nbr_of_time_intervals = 0;
      end
      
      for i=1:length(patterns_str)
        fprintf('Processing %d out of %d patterns\n', i, length(patterns_str));
        
        trigger = signal.parent.gettriggers(0, inf).get('tag', ...
          patterns_str{i});
        triggertimes = trigger.gettimes(neuron.tmin, neuron.tmax);
        
        for j=2:length(triggertimes)
          for tstop=triggertimes(j):-response_range:(triggertimes(j)-.5)
            tstart = tstop - response_range;
            
            nbr_of_time_intervals = nbr_of_time_intervals + 1;
            
            if xpsp_detected(psp, tstart, tstop)
              nbr_of_automatic_detections = nbr_of_automatic_detections + 1;
            end
          end
        end
      end
      
      spont_activity = nbr_of_automatic_detections/...
        nbr_of_time_intervals;
      
      fprintf('\n\n');
      fprintf('%s\t%.2f\n', signal.parent.tag, spont_activity);
      print_results('Automatic', fraction_automatic);
      print_results('Manual', fraction_manual);
      print_results('Both', fraction_both);
      print_results('Only automatic', fraction_only_automatic);
      print_results('Only manual', fraction_only_manual);
      print_results('None', fraction_none);
      
      
      function print_results(titlestr, values)
        fprintf('\t%s\t%.2f\t', titlestr, mean(values));
        fprintf('%.2f\t', values);
        fprintf('\n');
      end
      
    end
  end
end