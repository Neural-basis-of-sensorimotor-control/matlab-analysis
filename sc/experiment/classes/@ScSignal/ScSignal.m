classdef ScSignal < ScChannel & ScDynamicClass

  methods (Static)
    empty_class = make_empty_class()
  end
  
  %Analog imported channel
  properties
    
    dt                              % time resolution (1x1 double)
    waveforms                       % ScWaveform
    filter                          % ScSignalFilter
    simple_artifact_filter          % ScSimpleArtifactFilter
    simple_spike_filter             % ScSimpleSpikeFilter
    remove_waveforms                % ScList
    amplitudes                      % ScCellList
    N                               % nbr of data points (1x1 double)
    userdata
  
  end
  
  properties (Dependent)
    
    t
    istrigger
    triggers
  
  end
  
  methods
    
    function obj = ScSignal(parent, channelname, varargin)
      
      obj.parent                 = parent;
      obj.channelname            = channelname;
      obj.waveforms              = ScList;
      obj.filter                 = ScSignalFilter(obj);
      obj.remove_waveforms       = ScList();
      obj.amplitudes             = ScCellList();
      obj.simple_artifact_filter = ScSimpleArtifactFilter(obj);
      obj.simple_spike_filter    = ScSimpleSpikeFilter(obj);
      
      for k=1:2:numel(varargin)
        obj.(varargin{k}) = varargin{k+1};
      end
      
    end
    
    
    %Clear all properties
    function sc_clear(obj)
      
      for i=1:obj.waveforms.n
        obj.waveforms.get(i).sc_clear();
      end
      
    end
    
    
    %Load non-transient properties
    function sc_loadtimes(obj)
      
      for i=1:obj.waveforms.n
        obj.waveforms.get(i).sc_loadtimes();
      end
      
    end
    
    %Recalculate all waveform times with correct order vs filtering
    function recalculate_all_waveforms(obj)
      
      s.smooth = true;
      s.remove_artifacts = true;
      s.remove_waveforms = true;
      s.remove_artifacts_simple = true;
      
      v = obj.get_v(s);
      
      for k=1:obj.remove_waveforms.n
        
        rmwf = obj.remove_waveforms.get(k);
        rmwf.calibrate(v);
        v = rmwf.remove_wf(v);
        
      end
      
      for k=1:obj.waveforms.n
        
        wf = obj.waveforms.get(k);
        wf.recalculate_spiketimes(v,obj.dt);
        
      end
      
    end
    
    
    function recalculate_waveform(obj, wf)
      
      s.smooth = true;
      s.remove_artifacts = true;
      s.remove_waveforms = true;
      s.remove_artifacts_simple = true;
      
      v = obj.get_v(s);
      
      wf.recalculate_spiketimes(v,obj.dt);
      
    end
    
    
    function rmwfs = get_rmwfs(obj,tmin,tmax)
      
      rmwfs = ScList();
      
      for k=1:obj.remove_waveforms.n
        
        rmwf = obj.remove_waveforms.get(k);
        
        if rmwf.tstart<tmax && rmwf.tstop>=tmin
          rmwfs.add(rmwf);
        end
        
      end
      
    end
    
    
    function ampls = get_ampls(obj,tmin,tmax)
      
      ampls = ScCellList();
      
      for k=1:obj.amplitudes.n
        
        ampl = obj.amplitudes.get(k);
        
        if ampl.tstart<=tmax && ampl.tstop>=tmin
          ampls.add(ampl);
        end
        
      end
      
    end
    
    function istrigger = get.istrigger(~)
      istrigger = false;
    end
    
    function triggers = get.triggers(obj)
      
      triggers = ScCellList();
      
      for k=1:obj.waveforms.n
        triggers.add(obj.waveforms.get(k));
      end
      
      for k=1:obj.remove_waveforms.n
        triggers.add(obj.remove_waveforms.get(k));
      end
      
      spiketrain = get_userdata(obj, 'spiketrain');
      
      for i=1:length(spiketrain)
        triggers.add(spiketrain(i));
      end
      
    end
    
    
    function t = get.t(obj)
      t = (1:obj.N)'*obj.dt;
    end
    
    
    function sc_save(obj, varargin)
      obj.parent.sc_save(varargin{:});
    end
    
  end
  
  methods (Static)
    
    function obj = loadobj(a)
      
      a = loadobj@ScChannel(a);
      
      if isempty(a.remove_waveforms)
        a.remove_waveforms = ScList();
      end
      
      if isempty(a.amplitudes)
        a.amplitudes = ScCellList();
      end
      
      if isempty(a.simple_artifact_filter) || isstruct(a.simple_artifact_filter)
        a.simple_artifact_filter = ScSimpleArtifactFilter([]);
      end
      
      if isempty(a.simple_spike_filter)  || isstruct(a.simple_spike_filter)
        a.simple_spike_filter = ScSimpleSpikeFilter([]);
      end
      
      obj = a;
      obj.simple_artifact_filter.parent = obj;
      obj.simple_spike_filter.parent = obj;
      
    end
    
  end
  
end
