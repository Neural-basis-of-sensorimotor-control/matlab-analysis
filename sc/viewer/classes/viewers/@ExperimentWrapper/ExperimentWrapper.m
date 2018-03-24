classdef ExperimentWrapper < CloseRequestFigure
  
  properties (SetObservable, SetAccess = 'protected')
    experiment          %ScExperiment
    file                %ScFile
    sequence            %ScSequence
  end
  
  properties (SetObservable)
    has_unsaved_changes
        
    pretrigger = -.1
    posttrigger = .1
    xlimits = [-.1 .1]              %xlim value
    
    sweep = 1
    sweep_increment = 1
    plotmode = PlotModes.default
  end
  
  properties (Dependent)
    tmin
    tmax
  end
  
  
  methods
    
    function tmin = get.tmin(obj)
      tmin = obj.sequence.tmin;
    end
    
    
    function tmax = get.tmax(obj)
      tmax = obj.sequence.tmax;
    end
    
  end
end