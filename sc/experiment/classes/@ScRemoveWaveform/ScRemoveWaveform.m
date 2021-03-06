classdef ScRemoveWaveform < ScTrigger & ScFilter & ScDynamicClass
  
  properties
    
    parent
    original_stimtimes      %Spike times from original ScWaveform object
    stimpos                 %Post-calibration spike times (in integer position values)
    stimpos_offsets         %Offset to stimpos (in seconds)
    width                   %Total filter width
    tag
    v_median                %Vector to be subtracted in first calibration step
    v_interpolated_median   %Vector to be subtracted after last calibration step
    tstart                  %Only use stimpos where stimpos*parent.dt>=tstart
    tstop                   %Only use stimpos where stimpos*parent.dt<tstop
    apply_calibration = true
  
  end
  
  properties (Dependent)
    sigm
  end
  
  methods

    function obj = ScRemoveWaveform(parent_signal,trigger,width,apply_calibration,tstart,tstop)
      
      obj.parent = parent_signal;
      obj.width = width;
      obj.tstart = tstart;
      obj.tstop = tstop;
      obj.apply_calibration = apply_calibration;
      obj.initialize(trigger);
    
    end

    
    function v = apply(obj, v)
      v = obj.remove_wf(v);
    end
    
    function update(obj, v)
      obj.calibrate(v);
    end
    
    
    %Assuming that tmin = 0 for conversion from time to discrete time
    %steps
    function calibrate(obj,v)
      
      obj.stimpos = round(obj.original_stimtimes/obj.parent.dt)+1;
      use_stimpos = obj.stimpos>1 & obj.stimpos+obj.width<numel(v);
      use_stimpos = use_stimpos & obj.stimpos*obj.parent.dt>=obj.tstart & obj.stimpos*obj.parent.dt<obj.tstop;
      obj.stimpos = obj.stimpos(use_stimpos);
      obj.stimpos_offsets = obj.original_stimtimes(use_stimpos) - (obj.stimpos-1)*obj.parent.dt;
      
      if isempty(obj.stimpos)
      
        obj.v_interpolated_median = [];
        obj.v_median = [];
        obj.stimpos_offsets = zeros(size(obj.stimpos));
      
      elseif ~obj.apply_calibration
       
        [~,obj.v_interpolated_median,fwidth] = sc_remove_artifacts(v,obj.width+2,obj.stimpos-1);
        obj.v_interpolated_median = obj.v_interpolated_median(1:fwidth)';
        obj.v_median = obj.v_interpolated_median(2:end-1);
        obj.width = length(obj.v_median);
      
      else
        
        [~,obj.v_interpolated_median,fwidth] = sc_remove_artifacts(v,obj.width+2,obj.stimpos-1);
        obj.v_interpolated_median = obj.v_interpolated_median(1:fwidth)';
        obj.v_median = obj.v_interpolated_median(2:end-1);
        obj.stimpos_offsets = zeros(size(obj.stimpos));
        ranges = bsxfun(@plus,obj.stimpos,round([-obj.width/5 obj.width/5]));
        ranges(ranges<1) = 1*ones(size(find(ranges<1)));
        ranges(ranges>numel(v)-(obj.width+1)) = (numel(v)-(obj.width+1))*ones(size(find(ranges>numel(v)-(obj.width+1))));
        overlap = ranges(1:end-1,2)>=ranges(2:end,1);
        ranges(overlap,2) = floor((obj.stimpos([overlap; false])+obj.stimpos([false; overlap]))/2);
        ranges([false; overlap],1) = ranges([overlap; false],2)+1;

        max_nbr_of_iterations = 5;
        it = 1;
        prev_stimpos = [];
        
        while it<=max_nbr_of_iterations && (it==1 || ~nnz(prev_stimpos - obj.stimpos))
          
          [~,obj.v_median, obj.width] = sc_remove_artifacts(v,obj.width,obj.stimpos);
          obj.v_median = obj.v_median(1:obj.width);
          prev_stimpos = obj.stimpos;
          
          for i=1:numel(obj.stimpos)
            obj.stimpos(i) = obj.find_min(ranges(i,:),v);
          end
          
          it = it+1;
          
        end
        
        if it>max_nbr_of_iterations
          fprintf('Warning: Reached maximum number of iterations (=%i) in %s\n',max_nbr_of_iterations,mfilename);
        end
        
        obj.stimpos_offsets = zeros(size(obj.stimpos));
        [~,obj.v_interpolated_median] = sc_remove_artifacts(v,obj.width+2,obj.stimpos-1);
        t_index = (0:(obj.width+1))';
        times = t_index*obj.parent.dt;
        sp = spaps(times,obj.v_interpolated_median,1e-6);
        obj.v_interpolated_median = fnval(sp,times);

        it=1;
        max_nbr_of_iterations = 3;
        
        %todo: add check for convergence
        while it<=max_nbr_of_iterations
          
          for k=1:numel(obj.stimpos)
          
            s = v(obj.stimpos(k)+t_index) - v(obj.stimpos(k));
            ind = (2:obj.width+1)';
            Y = obj.v_interpolated_median(ind) - s(ind);
            X = .5*(s(ind-1) - obj.v_interpolated_median(ind+1));
            obj.stimpos_offsets(k) = X\Y + 2;
          
          end
          
          below_bounds = obj.stimpos_offsets < -1;
          above_bounds = obj.stimpos_offsets > 1;
          obj.stimpos_offsets(below_bounds | above_bounds) = zeros(size(find(below_bounds | above_bounds)));
          fprintf('%i offsets out of %i out of bounds\n',nnz(above_bounds | below_bounds),numel(obj.stimpos_offsets));
          obj.stimpos_offsets = obj.parent.dt*obj.stimpos_offsets;
          new_v_median = nan(obj.width,numel(obj.stimpos));

          pp = spaps(times,obj.v_interpolated_median,1e-6);
          
          for k=1:numel(obj.stimpos)
            new_v_median(:,k) = fnval(pp,times(2:end-1)+obj.stimpos_offsets(k));
          end
          
          obj.v_interpolated_median(2:end-1) = mean(new_v_median,2);
          %dbgplt(17+it,[],obj.v_interpolated_median);
          it = it+1;
        end
      end
      
    end

    
    function v = remove_wf(obj,v,~)
      
      if isempty(obj.v_interpolated_median)
        
        if ~isempty(obj.stimpos)
          msgbox(sprintf('You will need to calibrate ScRemoveWaveform %s',obj.tag));
        end
        
        return
      
      end
      
      f = obj.sigm;
      
      if obj.apply_calibration
        
        times = (0:(obj.width+1))'*obj.parent.dt;
        pp = spaps(times,obj.v_interpolated_median,1e-6);
        
        for k=1:numel(obj.stimpos)
          
          pos = obj.stimpos(k) + (0:obj.width-1)';
          v(pos) = v(pos) - f.*fnval(pp,times(2:end-1)+obj.stimpos_offsets(k));%f.*obj.v_interpolated_median(2:end-1)';%
        
        end
        
      else
        
        for k=1:numel(obj.stimpos)
        
          pos = obj.stimpos(k) + (0:obj.width-1)';
          
          if size(f,1)~=size(obj.v_median,1)
          
            warning('Matrix dimensions are not compatible, rearranging on the fly');
            obj.v_median = obj.v_median';
          
          end
          
          if isempty(obj.v_median)
            
            warning('Setting obj.v_median to zeros')
            obj.v_median = zeros(size(f));
          
          elseif ~nnz(obj.v_median)
            
            warning('Setting obj.v_median all zeros')
          
          end
          
          v(pos) = v(pos) - f.*obj.v_median;%f.*obj.v_interpolated_median(2:end-1)';%
        
        end
      end
      
    end

    
    function times = gettimes(obj,tmin,tmax)
    
      times = obj.stimpos*obj.parent.dt + obj.stimpos_offsets;
      times = times(times>=tmin & times<tmax);
    
    end
    
    
    function val = get.sigm(obj)
      
      tail_length = min(ceil(obj.width/3),20);
      last_f_val =1e-3;
      c = obj.width - tail_length;
      a = log(1/last_f_val-1)/(c-obj.width);
      val = sigmf((1:obj.width)',[a c]);
    
    end
    
  end
  
  
  methods (Access = 'protected')
    
    function minpos = find_min(obj,minmax,v)
      
      ressqrd = nan(sc_range(minmax)+1,1);
      indices = minmax(1):minmax(2);
      
      for j=1:numel(indices)
        residual = v(indices(j): (indices(j)+obj.width-1) )' - v(indices(j)) - obj.v_median;
        ressqrd(j) = sum(residual.^2);
      end
      
      [~,ind] = min(ressqrd);
      minpos = indices(ind);
    
    end

    
    function initialize(obj,trigger)
      
      obj.tag = ['#' trigger.tag];
      obj.original_stimtimes = trigger.gettimes(0,inf);%round(/obj.parent.dt);
      obj.stimpos = round(obj.original_stimtimes/obj.parent.dt)+1;
      obj.stimpos_offsets = obj.original_stimtimes - (obj.stimpos-1)*obj.parent.dt;
      below_one = find(obj.stimpos<1);
      above_max = find(obj.stimpos>obj.parent.N);
      obj.stimpos(below_one) = ones(size(below_one));
      obj.stimpos(above_max) = obj.parent.N*ones(size(above_max));
      obj.stimpos_offsets(below_one) = zeros(size(below_one));
      obj.stimpos_offsets(above_max) = zeros(size(above_max));
      
    end
    
  end

end
