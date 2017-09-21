classdef ScNeuron < handle
  
  % For storing meta data to enable repeatable automated analysis.
  % Use only primitive types as proeprty values
  
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
    comment
    xpsp_tag
    artifact_tag
    x
    y
    subcortical_depth_mm
    
  end
  
  
  methods
    
    function obj = ScNeuron(varargin)
      
      obj.tmin    = -inf;
      obj.tmax    = inf;
      obj.comment = '';
      
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
    
    
    function gui_mgr_out = load_experiment(obj, spiketrain_fcn)
      
      sc_dir = get_default_experiment_dir();
      
      gui_mgr = sc([sc_dir obj.experiment_filename], obj.file_tag);
      
      if nargout
        gui_mgr_out = gui_mgr;
      end
      
      if nargin > 1
        if isfunction(spiketrain_fcn)
          file = gui_mgr.viewer.file;
          
          signals = file.signals;
          
          signal = signals.get('tag', obj.signal_tag);
          
          set_userdata(signal, 'spiketrain', []);
          set_userdata(signal, 'spiketrain', spiketrain_fcn(signal));
        else
          
        end
      end
      
    end
    
    
    function load_experiment_amplitude_mode(obj, amplitude, sweep_nbr)
      
      sc_dir = get_default_experiment_dir();
      
      gui_mgr = sc('-amplitude', [sc_dir obj.experiment_filename], obj.file_tag);
      
      gui_mgr.viewer.set_amplitude(amplitude);
      gui_mgr.viewer.set_sweep(sweep_nbr);
      
    end
    
    
    function newobj = clone(obj)
      
      newobj = ScNeuron();
      
      mco = ?ScNeuron;
      plist = mco.PropertyList;
      
      for k=1:numel(plist)
        
        p = plist(k);
        
        if ~p.Dependent && ~p.Abstract && ~p.Constant
          newobj.(p.Name) = obj.(p.Name);
        end
        
      end
      
    end
    
  end
  
end