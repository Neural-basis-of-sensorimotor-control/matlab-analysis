classdef ScViewer < sc_viewer.ScSaveDataViewer & ...
    sc_viewer.ScHistogramViewer & sc_viewer.ScPlotViewer & ...
    sc_viewer.ScTriggerViewer & sc_viewer.ScExperimentViewer & ...
    sc_viewer.ScButtonViewer
  
  properties (SetAccess = protected, SetObservable)
    
    % User info text
    user_info
    
  end
  
end