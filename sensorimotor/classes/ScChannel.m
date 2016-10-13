classdef ScChannel < handle

  properties
    channelname
    parent
    tag
  end

  properties (Dependent)
    fdir
    is_adq_file
  end

  methods

    function fdir = get.fdir(obj)
      fdir = obj.parent.fdir;
    end

    function is_adq_file = get.is_adq_file(obj)
      is_adq_file = obj.parent.is_adq_file;
    end

  end

  methods (Static = true)
    %called before object is created from saved file
    function obj = loadobj(a)
      %to ensure backwards compatibility
      if ~a.is_adq_file() && isempty(a.tag)
        a.tag = a.channelname;
      end
      obj = a;
    end
  end
end

