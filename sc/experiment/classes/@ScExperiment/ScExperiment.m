classdef ScExperiment < ScList
  
  % Children: ScFile  
  properties
    
    save_name         %for saving this class, ends with _sc.mat
    last_gui_version
    
  end
  
  properties (SetAccess = protected)
    
    fdir % directory containing .mat / .adq files
    
  end
  
  methods (Static)
    
    experiment = load_experiment(fpath);
    
  end
  
  methods
    
    function obj = ScExperiment(varargin)
      
      for i=1:2:numel(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end
      
    end
    
    
    %clear all transient data
    function sc_clear(obj)
      
      for i=1:obj.n
        obj.get(i).sc_clear();
      end
      
    end
    
    
    %Initialize all children
    function init(obj)
      
      for i=1:obj.n
        
        fprintf('reading file: %i out of %i\n',i,obj.n);
        obj.get(i).init();
        
      end
      
    end
    
    
    function add_spike2_channels(obj)
      
      for k=1:obj.n
        
        fprintf('reading file: %i out of %i\n',k,obj.n);
        obj.get(k).add_spike2_channels();
        
      end
      
    end
    
    
    %Parse experimental protocol (*.txt)
    function update_from_protocol(obj, protocolfile)
            
      for i=1:obj.n
        
        fprintf('parsing file %i out of %i\n',i,obj.n);
        obj.get(i).update_from_protocol(protocolfile);
        
      end
      
    end
    
    
    %Get all spike times for trigger/spike object
    function spiketimes = get_spiketimes(obj,tag)
      
      t0 = 0;
      spiketimes = [];
      
      for k=1:obj.n
        
        file = obj.get(k);
        triggers = file.gettriggers(0,inf);
        
        if ~sc_contains(triggers.values('tag'),tag)
          
          fprintf('No waveform ''%s'' with detected spikes in file %s\n',tag,file.tag);
          
        elseif numel(sc_cellfind(triggers.values('tag'),tag))>1
          
          msgbox(sprintf('File %s contains more than one waveform/trigger named ''%s''.',file.tag,tag));
          
        else
          
          trigger = triggers.get('tag',tag);
          trigger.sc_loadtimes();
          spiketimes = [spiketimes; (t0 + trigger.gettimes(0,inf))]; %#ok<AGROW>
          
        end
        
        if file.signals.n
          
          N = cell2mat(file.signals.values('N'));
          dt = cell2mat(file.signals.values('dt'));
          file_length = max(N.*dt);
          
          if ~file_length
            
            msgbox(sprintf('Warning: it appears that file %s has never loaded yet - lack information about absolute time.',file.tag));
            return
            
          else
            
            t0 = t0 + file_length;
            
          end
          
        else
          
          msgbox(sprintf('No analog signal found in file %s. Cannot compute file time length',file.tag));
          
        end
        
      end
      
    end
    
    
    function print_status(obj)
      
      fprintf('Experiment: %s\n',obj.save_name);
      fprintf('Files:\n');
      
      for k=1:obj.n
        
        file = obj.get(k);
        fprintf('\t%s\n',file.tag);
        
        if ~isempty(file.user_comment)
          
          for j=1:size(file.user_comment,1)
            fprintf('\t/* %s\n',file.user_comment(j,:));
          end
          
        end
        
        for i=1:file.n
          
          sequence = file.get(i);
          
          for j=1:sequence.signals.n
            
            signal = sequence.signals.get(j);
            
            for m=1:signal.waveforms.n
              
              waveform = signal.waveforms.get(m);
              waveform.sc_loadtimes();
              spiketimes = waveform.gettimes(sequence.tmin,sequence.tmax);
              
              if ~isempty(spiketimes)
                fprintf('\t\t%s\t%s\t%s\t%i spikes\n',sequence.tag,signal.tag,waveform.tag,numel(spiketimes));
              end
              
            end
            
          end
          
        end
        
        for i=1:file.signals.n
          
          signal = file.signals.get(i);
          
          for j=1:signal.remove_waveforms.n
            
            rmwf = signal.remove_waveforms.get(j);
            fprintf('\t\trmwf\t%s\t%s\t%g - %g\n',signal.tag,rmwf.tag,rmwf.tstart,rmwf.tstop);
            
          end
          
        end
        
      end
      
    end
    
  end
  
end
