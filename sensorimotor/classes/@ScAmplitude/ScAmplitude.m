classdef ScAmplitude < handle
	
	properties
		parent_signal
		labels
		stimtimes
		data
		tag
		is_updated
		rise            %Mx1 double
		start           %Mx1 double
		stop            %Mx1 double
		is_pseudo       %Mx1 logical
		automatic_xpsp_detected %Mx1 logical
		is_median_and_automatic				%Mx1 logical
		middle_index    %M%1 logical
	end
	
	properties (Dependent)
		rise_automatic_detection
		width_automatic_detection
		
		tstart
		tstop
		rise_amplitude
		latency
		width
		valid_data
		N
		parent
	end
	
	methods
		
		function obj = ScAmplitude(parent_sequence, parent_signal, trigger, ...
				labels, tag, offset)
			obj.labels = labels;
			obj.parent_signal = parent_signal;
			obj.stimtimes = trigger.gettimes(parent_sequence.tmin,parent_sequence.tmax) + offset;
			obj.data = nan(numel(obj.stimtimes),numel(labels));
			obj.tag = tag;
			obj.is_updated = false;
		end
		
		
		function add_data(obj, stimtime, ind, x)
			[~,pos] = min(abs(stimtime-obj.stimtimes));
			for k=1:numel(ind)
				obj.data(pos,ind(k)) = (x(k));
			end
			obj.is_updated = false;
		end
		
		
		function val = get_data(obj, stimtime, ind)
			if nargin<3,    ind = numel(obj.labels);    end
			[~,pos] = min(abs(stimtime-obj.stimtimes));
			val = nan(size(ind));
			for k=1:numel(ind)
				if isfinite(obj.data(pos,ind(k)))
					val(k) = obj.data(pos,ind(k));
				end
			end
		end
		
		
		function times  =  gettimes(obj, tmin, tmax)
			times = obj.stimtimes(obj.stimtimes >= tmin & obj.stimtimes < tmax);
		end
		
		
		function sc_save(obj, varargin)
			obj.parent_signal.sc_save(varargin{:});
		end
		
		
		function ret = get.tstart(obj)
			if isempty(obj.stimtimes)
				ret = inf;
			else
				ret = min(obj.stimtimes);
			end
		end
		
		
		function ret = get.tstop(obj)
			if isempty(obj.stimtimes)
				ret = -inf;
			else
				ret = max(obj.stimtimes);
			end
		end
		
		
		function val = get.rise_amplitude(obj)
			ind = obj.valid_data;
			val = obj.data(ind,4) - obj.data(ind,2);
		end
		
		
		function val = get.latency(obj)
			ind = obj.valid_data;
			val = obj.data(ind,1);
		end
		
		
		function val = get.width(obj)
			ind = obj.valid_data;
			val = obj.data(ind,3) - obj.data(ind,1);
		end
		
		
		function val = get.valid_data(obj)
			val = all(isfinite(obj.data), 2);
		end
		
		
		function val = get.N(obj)
			val = length(obj.stimtimes);
		end
		
		function val = get.rise_automatic_detection(obj)
			val = obj.rise(obj.is_median_and_automatic);
		end
		
		
		function val = get.width_automatic_detection(obj)
			val = obj.width(obj.is_median_and_automatic);
		end
		
		
		function set.parent(obj, val)
			obj.parent_signal = val;
		end
		
		
		function val = get.parent(obj)
			val = obj.parent_signal;
		end
		
  end
  
  methods (Static)
    
    function obj = loadobj(a)
      
      if isempty(a.automatic_xpsp_detected)
        a.automatic_xpsp_detected = false(size(a.stimtimes));
      end
      
      obj = a;
    end
    
  end
	
end
