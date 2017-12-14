classdef ScExperimentViewer < handle
  
  properties (SetAccess = protected, SetObservable)
    
    experiment
    file
    sequence
    signal1
    signal2
    rmwf
    waveform
    threshold
    amplitude
    remove_spike
    
  end
  
end