classdef ScViewer < ScSaveDataViewer & ScHistogramViewer & ScPlotViewer & ...
    ScTriggerViewer & ScExperimentViewer & ScButtonViewer
  
  properties (SetAccess = protected, SetObservable)
    
    % User info text
    user_info
    
  end
  
end