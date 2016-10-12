classdef ScThreshold < handle
  properties
    position_offset
    v_offset
    lower_tolerance
    upper_tolerance

    max_matrix_size = 1e7   %can be changed to optimize speed and memory
    %usage, optimal value depends on available
    %RAM
    min_isi                 %min inter-spike interval (ISI) in bins
  end

  properties (Dependent)
    n
    width
  end

  methods
    function obj = ScThreshold(position_offset, v_offset, lower_tolerance, upper_tolerance)
      obj.min_isi = 1e2;
      obj.position_offset = position_offset;
      obj.v_offset = v_offset;%(ind);
      obj.lower_tolerance = lower_tolerance;%(ind);
      obj.upper_tolerance = upper_tolerance;%(ind);
      %Set highest abs v offset first, then highest deviation from
      %previous value as second
      [~,dim] = max(size(obj.v_offset));
      [~,ind] = sort(abs(obj.v_offset),dim,'descend');
      obj.v_offset = obj.v_offset(ind);
      obj.position_offset = obj.position_offset(ind);
      obj.lower_tolerance = obj.lower_tolerance(ind);
      obj.upper_tolerance = obj.upper_tolerance(ind);
      [~,ind] = sort(abs(obj.v_offset(1)-obj.v_offset(2:end)),dim,'descend');
      obj.v_offset(2:end) = obj.v_offset(ind+1);
      obj.position_offset(2:end) = obj.position_offset(ind+1);
      obj.lower_tolerance(2:end) = obj.lower_tolerance(ind+1);
      obj.upper_tolerance(2:end) = obj.upper_tolerance(ind+1);
    end

    function newobj = create_copy(obj)
      newobj = ScThreshold(obj.position_offset,obj.v_offset,...
        obj.lower_tolerance, obj.upper_tolerance);
      mco = ?ScThreshold;
      plist = mco.PropertyList;
      for k=1:numel(plist)
        p = plist(k);
        if ~p.Dependent && ~p.Abstract && ~p.Constant
          newobj.(p.Name) = obj.(p.Name);
        end
      end
    end

    %see ScWaveform for explanation
    %Uses no parfor loop - suitable when there is parallel computation
    %of several ScThreshold objects
    function [spikepos, spikearea] = match_v(obj,v)
      original_dim_v = size(v);
      if length(v)<=obj.max_matrix_size
        spikepos = ScThreshold.find_spikepos(obj,v);
        spikepos = sc_separate(spikepos,obj.min_isi);
      else
        [vcell,spikes] = obj.conv_v(v);
        clear v
        for k=1:length(spikes)
          spikes(k) = {ScThreshold.find_spikepos(obj,vcell{k})};
        end
        spikepos = obj.deconv_spikes(spikes);
      end
      if nargout>=2
        spikearea = obj.compute_spikearea(spikepos,original_dim_v);
      end
      spikepos = sc_separate(spikepos,obj.width);
    end

    %see ScWaveform for explanation
    %Uses parfor loop - suitable when there is no parallel computation
    %of several ScThreshold objects
    function [spikepos, spikearea] = match_v_parallel(obj,v)
      if length(v)<=obj.max_matrix_size
        if nargout<=1
          spikepos = obj.match_v(v);
        else
          [spikepos,spikearea] = obj.match_v(v);
        end
      else
        [vcell,spikes,original_dim_v] = obj.conv_v(v);
        clear v
        parfor k=1:length(spikes)
          spikes(k) = {ScThreshold.find_spikepos(obj,vcell{k})};
        end
        spikepos = obj.deconv_spikes(spikes);
        if nargout>=2
          spikearea = obj.compute_spikearea(spikepos,original_dim_v);
        end
        spikepos = sc_separate(spikepos,obj.width);
      end
    end
    %Rearrange v from matrix to cell, and create cell for containing
    %spikes
    function [vcell,spikes,original_dim_v] = conv_v(obj,v)
      original_dim_v = size(v);
      if size(v,2) > 1
        v = v';
      end
      startpos = 1:obj.max_matrix_size:length(v);
      stoppos = [(startpos(2:end)+obj.width) length(v)];
      stoppos(stoppos>length(v)) = length(v)*ones(size(find(stoppos>length(v))));
      spikes = cell(size(startpos));
      vcell = cell(size(spikes));
      for k=1:length(vcell)
        vcell(k) = {v((startpos(k):stoppos(k)))};
      end
    end

    %Rearrange spike from cell structure to matrix structure
    function spikepos = deconv_spikes(obj,spikes)
      for k=1:length(spikes)
        spikes(k) = {(k-1)*obj.max_matrix_size+spikes{k}};
      end
      spikepos = cell2mat(spikes');
      spikepos = sc_separate(spikepos,obj.min_isi);
    end

    %Reaturn logical vector where true means that bin is part of
    %threshold
    function spikearea = compute_spikearea(obj,spikepos,original_dim_v)
      spikearea = false(original_dim_v);
      batchsize = round(obj.max_matrix_size/obj.width);
      for startpos = 1:batchsize:numel(spikepos)
        endpos = min(startpos+batchsize,numel(spikepos));
        wfs = bsxfun(@plus,spikepos(startpos:endpos),0:(obj.width-1));
        spikearea(wfs(:)) = true(size(wfs(:)));
      end
    end

    function n = get.n(obj)
      n = numel(obj.position_offset);
    end

    function width = get.width(obj)
      width = max(obj.position_offset);
    end
  end

  methods (Static)
    function obj = loadobj(obj)
      if isempty(obj.min_isi)
        obj.min_isi = 1e2;
      end
    end
    function spikepos = find_spikepos(objh,v)
      spikepos = (1:length(v)-objh.width)';
      spikepos = spikepos( (v(objh.position_offset(1)+spikepos) - v(spikepos)) ...
        >= (objh.v_offset(1) + objh.lower_tolerance(1)) );
      spikepos = spikepos( ( v(objh.position_offset(1)+spikepos) - v(spikepos)) ...
        <= (objh.v_offset(1) + objh.upper_tolerance(1)) );
      for k=2:numel(objh.position_offset)
        spikepos = spikepos( (v(objh.position_offset(k)+spikepos) - v(spikepos)) ...
          >= (objh.v_offset(k) + objh.lower_tolerance(k)) );
        spikepos = spikepos( (v(objh.position_offset(k)+spikepos) - v(spikepos)) ...
          <= (objh.v_offset(k) + objh.upper_tolerance(k)) );
        end
      end
    end
  end
