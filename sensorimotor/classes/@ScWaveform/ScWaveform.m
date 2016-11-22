classdef ScWaveform < ScTrigger & ScList & ScTemplate
  %Response from particular neuron
  %children: ScThreshold
  properties
    parent                  %ScSignal
    spike2filename          %applicable when there are extra files with
    %spiketimes from Spike2
    tag
    detected_spiketimes     %spiketimes that are given by ScThreshold children
    imported_spiketimes     %imported from Spike2
    predefined_spiketimes   %e.g userdefined spiketimes
  end
  
  properties (Dependent)
    width
    min_isi
  end
  
  methods
    
    function obj = ScWaveform(parent, tag, spike2filename)
      obj.parent = parent;
      obj.tag = tag;
      obj.spike2filename = spike2filename;
    end
    
    
    function update(obj, v)
      obj.recalculate_spiketimes(v, obj.parent.dt);
    end
    
    
    %Load spike times from separate Spike2 file
    function sc_loadtimes(obj)
      
      if ~isempty(obj.spike2filename)
        fname = fullfile(obj.parent.fdir, obj.spike2filename);
      
        if isempty(who('-file', fname, 'spikes'))
          fprintf('Warning: could not find channel ''spikes'' in file %s.\n',fname);
        else
          d = load(fname, 'spikes');
          obj.imported_spiketimes = d.spikes.times;
        end
      end
    end
    
    %Clear data that is loaded from external file
    function sc_clear(obj)
      obj.imported_spiketimes = [];
    end
    
    % match waveforms in ScThreshold list to Nx1 vector v
    % Input:
    %   obj         class object handle
    %   v           Nx1 vector with analog signal
    %   outputType  'logical' (default), or 'indexes'
    % Returns:
    %   - spikepos      = positions in w with a match
    %   - spikearea     = Nx1 logical array with true for all points in v
    %   that are covered by a waveform
    function [spikepos, spikearea] = match_v(obj, v, outputType)
      
      if nargout<=1
        if ~obj.n
          spikepos = [];
        elseif obj.n==1
          spikepos = obj.get(1).match_v_parallel(v);
        else
          spikes = cell(obj.n, 1);
          thrs = obj.list;
          
          %par
          for k=1:obj.n
            spikes(k) = {thrs(k).match_v(v)};
          end
          
          spikepos = cell2mat(spikes);
        end
      else
        
        if nargin<3
          outputType = 'logical';
        end
        
        if strcmp(outputType,'logical')
          spikepos = nan(ceil(numel(v)/100),1);
          pos = 0;
          spikearea = false(size(v));
          
          for k=1:obj.n
            [spikepos_temp, wfarea_temp] = obj.get(k).match_v_parallel(v);
            spikearea = spikearea | wfarea_temp;
            spikepos(pos+1:pos+numel(spikepos_temp)) = spikepos_temp;
            pos = pos+numel(spikepos_temp);
          end
          
          spikepos = spikepos(1:pos);
        elseif strcmpi(outputType,'index')
          spikepos = nan(ceil(numel(v)/100),1);
          pos = 0;
          spikearea = zeros(size(v));
          for k=1:obj.n
            [spikepos_temp, wfarea_temp] = obj.get(k).match_v_parallel(v);
            spikearea(wfarea_temp) = k*ones(nnz(wfarea_temp),1);
            spikepos(pos+1:pos+numel(spikepos_temp)) = spikepos_temp;
            pos = pos+numel(spikepos_temp);
          end
          spikepos = spikepos(1:pos);
        else
          error('Illegal value of input parameter outputType: ''%s''',...
            outputType)
        end
      end
    end
    
    %Return all spike times between tmin and tmax
    function times = gettimes(obj, tmin, tmax)
      times = sc_separate(sort([obj.detected_spiketimes; obj.imported_spiketimes; ...
        obj.predefined_spiketimes]), obj.min_isi*obj.parent.dt);
      times = times(times>=tmin & times<tmax);
    end
    
    %Run through v and redo all thresholding
    function recalculate_spiketimes(obj, v, dt)
      obj.detected_spiketimes = obj.match_v(v)*dt;
    end
    
    %Get max width (in pixels) from ScThreshold object list
    function width = get.width(obj)
      width = max(cell2mat(obj.values('width')));
    end
    
    function val = get.min_isi(obj)
      if ~obj.n
        val = 100;
      else
        val = max(cell2mat({obj.list.min_isi}));
      end
    end
  end
end
