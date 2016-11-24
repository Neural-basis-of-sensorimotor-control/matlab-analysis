classdef Pattern < handle
  properties (SetAccess = public)
    name
    stim_electrodes
  end
  properties (Dependent)
    times
    types
  end
  methods
    function obj = Pattern(name)
      obj.name = name;
    end
    function add_stim_electrode(obj, stim_electrode)
      stim_electrode.parent = obj;
      if isempty(obj.stim_electrodes)
        obj.stim_electrodes = stim_electrode;
      else
        obj.stim_electrodes(length(obj.stim_electrodes)+1) = stim_electrode;
      end
    end
    function val = get.times(obj)
      val = cell2mat({obj.stim_electrodes.time});
    end
    function val = get.types(obj)
      val = {obj.stim_electrodes.type};
    end
  end
end