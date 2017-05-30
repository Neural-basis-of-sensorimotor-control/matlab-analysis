classdef ScNeuron < handle
  
  % For storing meta data to enable repeatable automated analysis.
  % Must only contain primitive data types.
  
  properties
    experiment_filename
    file_tag
    signal_tag
    tmin
    tmax
    time_sequences
    template_tag
    tag
    userdata
  end
  
  
  methods
    
    function obj = ScNeuron(varargin)
      
      obj.tmin = 0;
      obj.tmax = inf;
      
      obj.update_properties(varargin{:});
    end
    
    
    function update_properties(obj, varargin)
      
      i = 1;
      
      while i<=length(varargin)
        
        arg = varargin{i};
        
        if ischar(arg)
          i = i+1;
          obj.(arg) = varargin{i};
          
        elseif isa(arg, 'ScFile')
          obj.experiment_filename = arg.parent.save_name;
          obj.file_tag = arg.tag;
          
        else
          error('Input of type %s not valid', class(arg));
        end
        
        i = i+1;
      end
      
    end
    
    
    function load_experiment(obj, spiketrain_fcn)
      
      sc_dir = get_default_experiment_dir();
      
      gui_mgr = sc([sc_dir obj.experiment_filename], obj.file_tag);
      
      if nargin > 1
        file = gui_mgr.viewer.file;
        
        signals = file.signals;
        
        signal = signals.get('tag', obj.signal_tag);
        
        set_userdata(signal, 'spiketrain', []);
        set_userdata(signal, 'spiketrain', spiketrain_fcn(signal));
      end
      
    end
  end
  
end