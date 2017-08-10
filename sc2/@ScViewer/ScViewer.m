classdef ScViewer < handle
  
  properties (SetAccess = protected, SetObservable)
    
    user_info
    
    plot_mode
    plot_raw_data
    plot_waveforms
    
    experiment
    file
    sequence
    
    signal1
    signal2
    
    trigger_parent
    trigger_tag
    
    waveform
    threshold
    
    remove_spike
    
    amplitude
    
    v_equals_zero_for_t
    
    pretrigger
    posttrigger
    sweep
    sweep_increment
    
    hist_pretrigger
    hist_posttrigger
    hist_binwidth
    hist_mode
    
    signal_sweep_filename
    spike_filename
    hist_filename
    
  end
  
end